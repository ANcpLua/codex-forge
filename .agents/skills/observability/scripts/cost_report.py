#!/usr/bin/env python3
"""Aggregate UsageEvent JSONL into cost reports by day, model, and role."""

import json
import sys
from collections import defaultdict


def main():
    by_day: dict[str, float] = defaultdict(float)
    by_model: dict[str, float] = defaultdict(float)
    by_model_tokens: dict[str, int] = defaultdict(int)
    total_cost = 0.0
    total_tokens = 0
    count = 0

    for line in sys.stdin:
        try:
            event = json.loads(line.strip())
        except json.JSONDecodeError:
            continue

        cost = event.get("estimated_cost_usd", 0)
        tokens = event.get("total_tokens", 0)
        model = event.get("model", "unknown")
        day = event.get("timestamp", "")[:10]

        by_day[day] += cost
        by_model[model] += cost
        by_model_tokens[model] += tokens
        total_cost += cost
        total_tokens += tokens
        count += 1

    print(f"Events: {count}")
    print(f"Total cost: ${total_cost:.4f}")
    print(f"Total tokens: {total_tokens:,}")
    print()
    print("By day:")
    for day in sorted(by_day):
        print(f"  {day}: ${by_day[day]:.4f}")
    print()
    print("By model:")
    for model in sorted(by_model, key=lambda m: by_model[m], reverse=True):
        print(f"  {model}: ${by_model[model]:.4f} ({by_model_tokens[model]:,} tokens)")


if __name__ == "__main__":
    main()
