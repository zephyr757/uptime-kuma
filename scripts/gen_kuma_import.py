#!/usr/bin/env python3
"""
Generate an Uptime Kuma import JSON (v2) from a CSV file.

CSV format (header required): name,url,tag,interval
- name: Monitor name
- url: Full URL. The script will fix common typos (e.g., hnttps, hetp) and add http:// if missing
- tag: Optional tag (e.g., miniverse, ozdust, client:a). Multiple tags can be separated by ';'
- interval: Optional seconds between checks (default 60)

Usage:
  python3 scripts/gen_kuma_import.py input.csv output.json
"""
import csv
import json
import re
import sys

def normalize_url(u: str) -> str:
    s = u.strip()
    if not s:
        return s
    # fix common typos
    s = re.sub(r"^(h+\s*t+\s*t+\s*p+\s*s?\s*):/+", lambda m: m.group(1).replace(" ", "") + "://", s, flags=re.I)
    s = s.replace("hnttps://", "https://").replace("hetps://", "https://").replace("hetp://", "http://").replace("hhttps://", "https://").replace("httos://", "https://").replace("htp://", "http://")
    s = s.replace(" https://", "https://").replace(" http://", "http://")
    if not re.match(r"^[a-zA-Z][a-zA-Z0-9+.-]*://", s):
        s = "http://" + s
    # collapse multiple slashes after scheme
    s = re.sub(r"(https?://)/+", r"\1", s)
    return s

def main():
    if len(sys.argv) != 3:
        print(__doc__)
        sys.exit(2)
    inp, outp = sys.argv[1], sys.argv[2]
    monitors = []
    tags_set = set()
    with open(inp, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            name = (row.get("name") or "").strip()
            url = normalize_url(row.get("url") or "")
            tag_field = (row.get("tag") or "").strip()
            interval = row.get("interval") or "60"
            if not name or not url:
                continue
            tags = [t.strip() for t in tag_field.split(";") if t.strip()] if tag_field else []
            for t in tags:
                tags_set.add(t)
            mon = {
                "name": name,
                "type": "http",
                "url": url,
                "interval": int(interval) if interval.isdigit() else 60,
                "method": "GET",
            }
            if tags:
                mon["tags"] = tags
            monitors.append(mon)

    data = {
        "version": 2,
        "tags": [{"name": t, "color": "#1f77b4"} for t in sorted(tags_set)],
        "monitors": monitors,
    }
    with open(outp, "w", encoding="utf-8") as wf:
        json.dump(data, wf, indent=2)
    print(f"Wrote {outp} with {len(monitors)} monitors and {len(tags_set)} tags.")

if __name__ == "__main__":
    main()

