# SQL Projects

I use SQL the way a product manager should: to answer a business question quickly, check whether an assumption holds, and find the pattern behind a recurring problem before deciding what to build.

Every project here starts with a question, shows the queries, and ends with what I'd do about the answer. All the scripts run as they are on PostgreSQL 14 or later.

| Project | The question | What it shows |
|---|---|---|
| [**Music store analysis**](./music-store-analysis) | Where does revenue come from, and where should the next marketing rupee go? | Joins, CTEs, window functions, ranking within groups |
| [**Inventory management system**](./inventory-management-system) | What's running low, what's selling, and what should we reorder this month? | Schema design, constraints, a trigger that keeps stock in sync, views, reconciliation checks |
| [**SQL murder mystery**](./sql-murder-mystery) | Can a vague brief be narrowed to one answer through small, checkable queries? | Breaking down an ambiguous problem, multi-table filtering |

## Highlights

- **Music store:** revenue is spread across 24 countries, not concentrated in a few customers. The top 20% of customers bring in only 28% of revenue. So growth would come from keeping the many, not from chasing a handful of big spenders.
- **Inventory:** stock updates automatically on every sale or purchase, the database refuses a sale larger than the stock on hand, and a reconciliation query proves stock on hand matches the transaction log. These are the same guardrails I'd write into acceptance criteria for any transaction journey.
- **Murder mystery:** five small steps from a crime-scene report to the person behind it, with each step's query and result saved separately.

## Run it

```bash
git clone https://github.com/Sriram200009/SQL-Projects.git
cd SQL-Projects
```

Each folder's README has its own setup steps.

## Skills

`SELECT` · joins · subqueries · CTEs · window functions (`RANK`, `ROW_NUMBER`, `NTILE`) · aggregation · schema design · constraints · triggers · views · PostgreSQL

---

More of my work: [github.com/Sriram200009](https://github.com/Sriram200009) · [LinkedIn](https://www.linkedin.com/in/sriram-aramuthan)
