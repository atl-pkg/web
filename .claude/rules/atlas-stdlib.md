# Atlas Stdlib Usage — Web Package Rules

Canonical reference: `~/dev/projects/atlas/docs/stdlib/`

## Collections (CoW — always reassign)

```atlas
// Map
let mut m = new Map<string, string>();
m = m.set("key", "val");          // reassign required
let v = m.get("key");             // returns Option<string>
let v2 = m.get("key").unwrapOr("");
m = m.delete("key");              // reassign required

// Array
let mut arr: string[] = [];
arr = arr.push("item");           // reassign required
arr = arr.filter(fn(x) { x != "" });  // reassign required
arr = arr.map(fn(x) { x.toUpperCase() });

// Set
let mut s = new Set<string>();
s = s.add("item");                // reassign required
let has = s.has("item");          // bool, no reassign needed
```

## Option<T>

```atlas
// file.read() returns Option<string>
let content = file.read("path.html");
match content {
    Some(body) => body,
    None => { return not_found(); }
}
// or: content.unwrapOr("")
// or: content.isSome() to check

// Map.get() returns Option<V>
let val = req_headers.get("content-type").unwrapOr("");
```

## Result<T, E>

```atlas
// Json.stringify() returns Result<string, string>
let body = Json.stringify(data).unwrapOr("{}");
// or match:
match Json.stringify(data) {
    Ok(s) => s,
    Err(e) => { return internal_error(e); }
}

// Json.parse() returns Result<any, string>
match Json.parse(raw_body) {
    Ok(parsed) => parsed,
    Err(_) => { return bad_request("invalid JSON"); }
}
```

## String methods (dot syntax)

```atlas
s.length()              // number
s.toUpperCase()
s.toLowerCase()
s.trim()
s.split(",")            // string[]
s.includes("sub")       // bool
s.startsWith("http")    // bool
s.replace("a", "b")     // replaces first
s.replaceAll("a", "b")  // replaces all
s.slice(0, 5)
s.indexOf("sub")        // number (-1 if not found, NOT Option)
```

## Math / number

```atlas
Math.floor(x)
Math.ceil(x)
Math.min(a, b)
Math.max(a, b)
Math.abs(x)
(3.14159).toFixed(2)    // "3.14"
```

## Json

```atlas
Json.stringify(value): Result<string, string>
Json.parse(str): Result<any, string>
```
`json` type is isolated — cannot implicitly assign to/from other types. Use explicit coercion.

## process / io

```atlas
process.env("KEY"): Option<string>
process.exit(code): never
io.print("msg")         // stdout, no newline
io.println("msg")       // stdout + newline
```

## DateTime

```atlas
let now = DateTime.now();
DateTime.fromTimestamp(ms): DateTime
now.toISOString(): string
now.addDays(n): DateTime
```

## BANNED (removed in B20-B35 — emit AT0002)

```
arrayPush(arr, item)        ❌ → arr = arr.push(item)
hashMapGet(map, key)        ❌ → map.get(key)
hashMapSet(map, k, v)       ❌ → map = map.set(k, v)
abs(x)                      ❌ → Math.abs(x)
```
