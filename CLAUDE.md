# atl-pkg/web

## Identity
**Atlas standard library web package** — the `net/http`-equivalent for Atlas programs.
Provides HTTP server bootstrap, request/response lifecycle, routing, middleware, templating, HTMX helpers, static file serving, sessions, and HTTP client. Written entirely in Atlas (`.atl` files).

Reference: Atlas language spec at `~/dev/projects/atlas/docs/`

## Session Start (every agent, every session)
```bash
pt go                  # sitrep: session ID, P0s, handoff, gotchas
pt issue-map           # priority×component matrix — orient before drilling
pt in-progress         # what's already claimed — no duplicates
```
`pt issue H-XXX` for full detail. See `.claude/lazy/pt-workflow.md` for complete pt reference.

## Writing Atlas Code (NON-NEGOTIABLE)

### CoW Writeback — #1 gotcha in this codebase
Atlas collections (Map, Array, Set) are **copy-on-write**. Mutations return a new value — the original is unchanged.
```
// ❌ WRONG — silent no-op
params.set("key", "val")
arr.push(item)

// ✅ CORRECT — always reassign
params = params.set("key", "val")
arr = arr.push(item)
routes = routes.push(route)
```
Every `.set()`, `.push()`, `.pop()`, `.delete()`, `.concat()`, `.filter()`, `.map()` call **must** be assigned back.

### Option / Result — always handle, never assume
```
// ❌ WRONG
let val = map.get("key")   // val is Option<string>, not string

// ✅ CORRECT
let val = map.get("key").unwrapOr("default")
// or: match map.get("key") { Some(v) => v, None => ... }
```
`file.read()` → `Option<string>` (Some = content, None = not found).
`Json.stringify()` / `Json.parse()` → `Result<T, string>`.

### Dot Access — always use method syntax
```
// ❌ WRONG (removed in B20-B35, emits AT0002)
arrayPush(arr, item)
hashMapGet(map, key)

// ✅ CORRECT
arr = arr.push(item)
map.get("key")
```

### Type signatures — always required on named functions
```
function handler(req: any): any { ... }    // ✅ — function keyword + return type
function handler(req) { ... }              // ❌ — return type required
fn handler(req: any): any { ... }          // ❌ — fn is for closures only (D-072)
```

### Response shape — always a Map
All handlers must return the standard response map:
```
{ status: number, body: string, headers: Map<string, string> }
```
Use helpers from `response.atl`: `ok(body)`, `json_resp(data)`, `not_found()`, etc.

## Testing
No test runner exists for Atlas packages yet. Manual integration tests go in `test_integration.atlas` at project root. Run with the Atlas CLI when the compiler supports it.

## Branch Rule
All source changes → branch required. Docs, CLAUDE.md, `.claude/**` → main OK.
Branch naming: `fix/H-XXX` | `feat/H-XXX` | `feat/short-name`

## Source of Truth
Atlas stdlib spec: `~/dev/projects/atlas/docs/stdlib/`
Atlas language spec: `~/dev/projects/atlas/docs/language/`
Code is authoritative over any README or inline comments in this repo.

## Auto-Loaded Rules
- `.claude/rules/atlas-stdlib.md` — correct Atlas stdlib usage patterns for this package
