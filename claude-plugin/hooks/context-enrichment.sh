#!/bin/zsh
# Context enrichment hook — runs before every prompt
# Searches the KB for terms in the user's message and injects results as context

export PATH="$HOME/bin:/usr/local/bin:$PATH"
QMD="$HOME/bin/qmd"

# Read the full payload from stdin
PAYLOAD=$(cat)

# Extract prompt text from the JSON payload
PROMPT=$(echo "$PAYLOAD" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    print(d.get('prompt', ''))
except:
    pass
" 2>/dev/null)

# Skip if no prompt or very short
if [ ${#PROMPT} -lt 10 ]; then
  exit 0
fi

# Extract meaningful search terms
# Priority: capitalized proper nouns (names, products), then longer keywords
TERMS=$(echo "$PROMPT" | python3 -c "
import sys, re
text = sys.stdin.read()

# Grab proper nouns (capitalized mid-sentence) and long words
proper = re.findall(r'(?<!\. )(?<!\n)\b([A-Z][a-zA-Z]{2,})\b', text)
keywords = re.findall(r'\b([a-zA-Z]{5,})\b', text)

stopwords = {
    'this','that','with','have','from','they','them','their','been','will',
    'would','could','should','about','which','there','where','when','what',
    'your','more','than','some','like','just','also','into','over','after',
    'before','these','those','then','here','make','want','need','help','know',
    'think','going','doing','using','look','give','take','much','many','well',
    'good','great','does','dont','cant','wont','tell','show','find','work',
    'please','claude','search','query','prompt','question','answer',
    'mapbox','search','product','team','feature','build','write','update',
}

seen = set()
terms = []
# Proper nouns first
for w in proper:
    if w.lower() not in stopwords and w.lower() not in seen:
        seen.add(w.lower())
        terms.append(w)
    if len(terms) >= 4:
        break

# Then keywords
for w in keywords:
    if w.lower() not in stopwords and w.lower() not in seen:
        seen.add(w.lower())
        terms.append(w)
    if len(terms) >= 7:
        break

print(' '.join(terms))
" 2>/dev/null)

# Skip if no useful terms found
if [ -z "$TERMS" ]; then
  exit 0
fi

# Build two query variants for broader recall
QUERY1="$TERMS"
QUERY2=$(echo "$TERMS" | awk '{print $1, $2, $3}')  # first 3 terms only

# Run searches sequentially (each <0.3s, total well under 2s budget)
RESULTS1=$("$QMD" search "$QUERY1" 2>/dev/null | grep -v "sqlite-vec" | head -30)
RESULTS2=$("$QMD" search "$QUERY2" 2>/dev/null | grep -v "sqlite-vec" | head -20)

# Combine and deduplicate
COMBINED=$(printf '%s\n%s\n' "$RESULTS1" "$RESULTS2" | awk '!seen[$0]++')

if [ -z "$COMBINED" ]; then
  exit 0
fi

# Output context block — Claude sees this, it doesn't appear in the chat UI
echo "<context>"
echo "Second Brain KB — search terms: $TERMS"
echo "---"
echo "$COMBINED" | head -60
echo "</context>"
