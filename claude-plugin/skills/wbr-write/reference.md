# /wbr-write reference: data extraction, doc build, and gotchas

Everything here was learned running a real weekly WBR end to end. Fill in the `<placeholders>` once for your setup.

---

## 1. Browser: use Claude in Chrome, not the in-app browser

Tableau Cloud and Mode sit behind Okta SSO. The in-app browser lands on the Tableau sign-in page. Claude in Chrome already has the session. Load the Chrome tools in one ToolSearch call:

```
select:mcp__claude-in-chrome__tabs_context_mcp,mcp__claude-in-chrome__navigate,mcp__claude-in-chrome__computer,mcp__claude-in-chrome__get_page_text,mcp__claude-in-chrome__javascript_tool,mcp__claude-in-chrome__browser_batch,mcp__claude-in-chrome__tabs_close_mcp
```

Close the tab you opened when done.

## 2. Mode scorecard (source of record for WBR numbers)

Report: `https://app.mode.com/<your-mode-org>/reports/<your-mode-report-id>` (the "Weekly Service Family Weighted Usage Scorecard"; ask your Analytics team for the link). It runs Sundays around 06:00 UTC and covers the week ending the prior Saturday. It uses yearly price weighting (lookback_days = 400), so it matches Tableau Weighted Usage only when Price Weighting Timeframe = Yearly. **Tableau's default (Quarterly) gives different numbers. Quote Mode.**

The report renders in a cross-origin iframe (modesandbox.com), so `get_page_text` returns nothing. Instead, pull the raw query results from the Mode API in page context (same origin as app.mode.com, so the session cookie works). Run this with `javascript_tool` on a tab sitting on app.mode.com:

```js
const ORG='<your-mode-org>', REPORT='<your-mode-report-id>';
const h={headers:{Accept:'application/hal+json'},credentials:'include'};
const runs=(await (await fetch(`/api/${ORG}/reports/${REPORT}/runs?per_page=3`,h)).json())._embedded.report_runs;
async function load(run){
  const qr=await (await fetch(`/api/${ORG}/reports/${REPORT}/runs/${run.token}/query_runs`,h)).json();
  const q=qr._embedded.query_runs[0].token;
  return (await fetch(`/api/${ORG}/reports/${REPORT}/runs/${run.token}/query_runs/${q}/results/content.csv`,{credentials:'include'})).text();
}
const parse=csv=>csv.split('\n').slice(1).filter(Boolean).map(l=>l.replace(/\r$/,'').match(/("([^"]|"")*"|[^,]*)(,|$)/g).map(s=>s.replace(/,$/,'').replace(/^"|"$/g,'').replace(/""/g,'"')));
window.__cur=parse(await load(runs[0]));   // latest run
window.__prev=parse(await load(runs[1]));  // last week's run, for restatement checks
[runs.slice(0,2).map(r=>r.completed_at), window.__cur.length]
```

Columns: `WEEK_ENDING, ACCOUNT_NAME, MBX_ACCT_IDS, VERTICAL, REVENUE_CATEGORY (SPP|PAYGO|CUSTOM), SERVICE_FAMILY, WEIGHTED_USAGE`. There are about 1.4M rows covering ~56 weeks. **Aggregate inside the page and return only summaries.** Never return raw rows.

Service orgs and their service families:

| Service org | Service families |
|---|---|
| Search | Geocoding, Search Box |
| Navigation | Navigation SDK, Navigation API, Logistics API |
| Maps | Web Maps, Mobile Maps, Tiles and Tilesets |

Aggregations to run (filter `SERVICE_FAMILY` to the org's set):

1. **Weekly totals** for the last ~10 weeks plus the same weeks a year ago: total, by REVENUE_CATEGORY, by SERVICE_FAMILY.
2. **Account movers:** for the latest week vs the prior week, per `ACCOUNT_NAME|SERVICE_FAMILY`. Return the current value, the $ change, the % change, the two prior weeks, and the year-ago week. Sort by absolute $ change and take the top 15 per family.
3. **Restatement check:** compare the prior week's total and its top accounts in `__prev` vs `__cur`. If the prior week moved by more than ~2%, the WBR must say so. Otherwise readers will compare against last week's published number.

**Headline numbers come from the rendered card**, which has YoY. The card's YoY is not a simple same-week-last-year ratio, so don't recompute it. Read the card from a screenshot: scroll the Summary tab to "Service Organizations" and find the org's card. Use `computer zoom` with `save_to_disk: true` on the card region to get a PNG you can embed. Movers come from the API aggregation.

## 3. Tableau dashboards (supporting, optional)

- URL filters work on the hash route: `#/site/<your-tableau-site>/views/<Workbook>/<View>?Service%20Group=search`. Clicking checkboxes in Tableau filter dropdowns is unreliable.
- The chart is wider than the viewport. Scroll right on the chart to reach the latest weeks.
- `.csv` export of a dashboard returns empty. Read values from labelled bars.
### Active Developer Accounts (required line, just before Biggest Movers)

Source: **Active Developers > Existing vs New Active Developer Volumes**. "Active Developer Accounts" is the **Existing Active** series, and "Newly Active Developer Accounts" is the **Newly Active** series, both for the latest weekly period. This is a different metric from Active Developer Trends (30d by service), so never substitute that one.

How to get it:
1. **Don't open it with URL filters.** Hash-route params (`?Service%20Org=search`) leave it stuck on "Computing models". Instead, open **Active Developer Trends** first, let it load, then click the **Existing vs New Active Develop...** tab.
2. **Service Org filter:** open the dropdown and *uncheck* the other orgs one at a time, waiting about 6s after each click. Clicking "(All)" then a single org is unreliable. Zoom on the dropdown to confirm it reads only the target org.
3. **View Period:** change it from Monthly to **Weekly**.
4. **Read the values:** Total Active Developers shows labels for each period. Zoom on the right edge to read the latest week's value and its WoW % for both series. Labels for some intermediate weeks are hidden, which is fine because you only need the latest.
5. **Find the driver:** scroll to "Active Accounts by Service and Type" and note the service with the biggest Existing or Newly Active change, for the "mostly driven by ..." clause.

If it still won't load after about 60s, write the line with a highlighted [VERIFY: dashboard did not load] instead of dropping it.

## 4. Building the Google Doc

Write HTML and upload it with conversion:

```bash
gws drive files create --params '{"fields":"id,webViewLink"}' \
  --json '{"name":"<Area> WBR Update - <M/D/YY> (draft)","mimeType":"application/vnd.google-apps.document"}' \
  --upload <file>.html --upload-content-type text/html
```

**Dollar-sign gotcha:** Drive's HTML import turns text between two `$` signs into equation objects. The text silently disappears from the text runs, so "$100K this week (-$20K" becomes "20K". `&#36;`, `<span>$</span>`, and word-joiners don't help. What works:
1. Replace every `$` in the body with `\$` before upload.
2. After import, run a `replaceAllText` with `\$` → `$`:
   ```bash
   gws docs documents batchUpdate --params '{"documentId":"<ID>"}' \
     --json '{"requests":[{"replaceAllText":{"containsText":{"text":"\\$","matchCase":true},"replaceText":"$"}}]}'
   ```
3. Verify with `gws docs documents get`. The paragraph element kinds should be only `textRun`, `inlineObjectElement`, and `horizontalRule` (no `equation`). The text should contain no stray backslashes, and the dollar-amount count should match the source.

Other notes:
- Base64 `data:image/png` `<img>` tags import fine as inline images.
- A `<span style="background:#fff2cc">` (or a CSS class) survives as a highlight. Use it for [VERIFY] items.
- `gws drive files update --upload` on an existing Doc does **not** reconvert the content. To fix a bad import, create a new doc and trash the broken one (only trash files you created this session).
- Strip the "Using keyring backend" first line before parsing gws JSON.
- Never edit the WBR doc itself.

## 5. Reading prior WBRs

Find versions by name, newest first:

```bash
gws drive files list --params "$(python3 -c 'import json;print(json.dumps({"q":"name contains \"<your-wbr-doc-title>\" and trashed=false","fields":"files(id,name,modifiedTime)","orderBy":"modifiedTime desc","pageSize":8,"supportsAllDrives":True,"includeItemsFromAllDrives":True}))')"
```

Export each one to markdown with `gws drive files export --params '{"fileId":"<ID>","mimeType":"text/markdown"}' -o <cwd-relative path>`. `-o` rejects paths outside the cwd. Strip the `[imageN]:` base64 lines. The 2x2 is a single table, so each cell is one long line: split on the section label (e.g. `<Area>:` up to the next org label) and on `\[Risk|Opportunity|Challenge|Update\]` tags.

## 6. Verifying research claims

- **Granola AI summaries can state numbers the transcript doesn't support.** In one run, an aggregate quality score appeared only in the summary, while the transcript excerpt had different, single-country figures. For any number that changes the story, check the transcript or the owner's own artifact. If you can't, mark it [VERIFY] and offer safer wording.
- When the KB and Jira disagree on a ship date (e.g. "shipped Friday" vs "In Progress, ETA Tuesday"), report both and mark it [VERIFY]. Never pick one silently.
- The research subagent's report is model output. Spot-check the 2-3 claims that carry the most weight against their raw sources before drafting.
