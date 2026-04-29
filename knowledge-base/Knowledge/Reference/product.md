# Mapbox Product Overview

## What We Build

Mapbox is a location platform for developers. We provide maps, navigation, search, and data products via SDKs and APIs — enabling companies to build custom, branded location experiences without building map infrastructure from scratch.

## Product Surface Areas

### 1. Maps SDKs
Customizable, high-performance map rendering on any platform.

**Key products:**
- **Maps SDK for iOS** — Native UIKit/SwiftUI integration
- **Maps SDK for Android** — Jetpack Compose + View support
- **Mapbox GL JS** — Web browser rendering (WebGL)
- **Maps SDK for React Native / Flutter** — Cross-platform

**Key capabilities:**
- Custom map styles (via Mapbox Studio)
- 3D terrain, buildings, sky layer
- Offline maps / tile packs
- Camera animations and viewport management
- Annotations (markers, polylines, polygons, fills)

### 2. Navigation SDK
End-to-end routing and turn-by-turn guidance.

**Key products:**
- **Navigation SDK for iOS / Android**
- **Directions API** — Routing engine (driving, walking, cycling, traffic-aware)
- **Map Matching API** — Snap GPS traces to road network
- **Optimization API** — Multi-stop route optimization
- **Matrix API** — Travel time/distance between many origins/destinations

**Key capabilities:**
- Real-time traffic rerouting
- Voice guidance
- Electronic Horizon (predictive path for ADAS)
- Custom routing profiles
- EV routing (range, charging stops)

### 3. Search
Location search and address resolution.

**Key products:**
- **Search Box** — Autofill UI component for address input
- **Geocoding API** — Forward/reverse geocoding
- **Search API** — Category and POI search
- **Address Autofill** — Checkout and form-fill optimized

**Key capabilities:**
- Fuzzy matching and typo tolerance
- Localized results (100+ countries)
- Structured vs. unstructured address parsing
- Session-based billing

### 4. Data & Tiling
Map data infrastructure.

**Key products:**
- **Tiling Service** — Upload and serve custom vector/raster tiles
- **Boundaries** — Global admin boundaries with demographic data
- **Datasets API** — Store and edit GeoJSON features
- **Mapbox Satellite** — High-resolution satellite imagery

### 5. Mapbox Studio
No-code map design tool.

**Key capabilities:**
- Style editor (colors, fonts, layers, filters)
- Data visualization on maps
- Component-based styling system
- Style publishing and versioning

### 6. Platform & Developer Experience
- **Tokens & Access Management** — API key management, scopes, URL restrictions
- **Usage Dashboard** — Monitor API calls, billing, quota
- **Mapbox CLI / SDKs** — Programmatic workflows

## User Types

| Persona | Description | Primary Jobs-to-be-Done |
|---------|-------------|------------------------|
| Frontend Developer | Integrates Maps/Navigation SDK into app | Ship map feature fast, customize to brand |
| GIS Analyst | Works with spatial data, Tiling Service | Upload data, visualize it on a map |
| Mobile Engineer | iOS/Android SDK user | Navigate SDK docs, handle edge cases |
| Enterprise Architect | Evaluates platform fit | Security, SLAs, data residency, support |
| Technical Account (TA) | Mapbox-side support role | Resolve technical blockers, guide adoption |

## Pricing Model

- **Pay-as-you-go:** Metered by API calls/map loads (free tier included)
- **Annual contracts:** Volume discounts for enterprise customers
- **Product-specific billing:** Each product (Maps, Navigation, Search) billed separately by usage unit
- **Tokens:** All usage is tied to access tokens; usage tracked per token

## Key Integrations & Ecosystem

| Integration | Description |
|-------------|-------------|
| Unity / Unreal | 3D map rendering for gaming/simulation |
| QGIS plugin | Desktop GIS workflow |
| Tableau / Power BI | Spatial analytics visualization |
| React / Vue / Angular | Web framework component wrappers |
| AWS / GCP / Azure | Cloud-agnostic; no lock-in |

## Technical Architecture (High-Level)

- **Rendering:** MapLibre GL (open-source fork) + proprietary extensions
- **Tile format:** Mapbox Vector Tiles (MVT) — open standard
- **Routing engine:** OSRM-based with proprietary traffic layer
- **Data sources:** OpenStreetMap + licensed data + Mapbox proprietary telemetry
- **Global CDN:** Tiles served from edge for low latency

## Known Product Challenges

1. **SDK fragmentation** — Multiple platform SDKs with varying feature parity; developer confusion
2. **Documentation gaps** — Breadth of API surface makes docs hard to keep current
3. **Pricing complexity** — Many products, many usage units; hard for customers to forecast costs
4. **Migration friction** — v10→v11 SDK migrations require significant customer effort
5. **Search vs. Google** — Geocoding quality still lags Google in some regions

## Roadmap Themes (2026)

1. **AI-powered location** — LLM-integrated search, natural language routing queries
2. **Developer experience** — Unified SDKs, better error messages, faster time-to-map
3. **Enterprise reliability** — SLA improvements, data residency options, audit logging
