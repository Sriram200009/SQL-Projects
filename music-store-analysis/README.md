# Music Store Analysis

**The question:** a digital music store wants to grow. Where does its revenue actually come from, and where should it focus its next campaign?

**Data:** the store's public sample database (PostgreSQL): 59 customers, 614 invoices, 11 tables covering customers, invoices, tracks, albums, artists, genres and employees.

![Database schema](https://user-images.githubusercontent.com/112153548/213707717-bfc9f479-52d9-407b-99e1-e94db7ae10a3.png)

## What the data says

| Finding | Number | So what |
|---|---|---|
| Revenue is spread wide, not concentrated in a few big spenders | Top 20% of customers = **28%** of revenue | No "whale" segment to chase. Growth means keeping the many: retention beats acquisition of a few big spenders |
| One country leads, but the long tail matters | USA **22%**, top 5 countries **58%**, 24 countries in all | Launch in the US first, but budget for the other 42% |
| One genre dominates demand | Rock = **55%** of tracks sold, then Metal 13%, Alternative & Punk 10% | Lead promotions and recommendations with Rock |
| A clear city for a live event | Prague has the highest invoice total (**273**) | The answer to "where do we host the promotional festival?" |

## Questions answered (all in [`analysis_queries.sql`](./analysis_queries.sql))

| # | Question | Technique |
|---|---|---|
| 1 | Who is the most senior employee? | `ORDER BY ... LIMIT` |
| 2 | Which country has the most invoices? | `GROUP BY` |
| 3 | What are the top 3 invoice totals? | Sorting |
| 4 | Which city should host a promotional festival? | Aggregation |
| 5 | Who is the best customer? | Joins + aggregation |
| 6 | Who are all the Rock listeners (for a targeted email)? | Subquery |
| 7 | Which 10 artists wrote the most Rock tracks (for an artist partnership)? | Multi-table joins |
| 8 | Which tracks run longer than average? | Scalar subquery |
| 9 | How much has each customer spent on the best-selling artist? | CTE |
| 10 | What's the most popular genre in each country, ties included? | Two CTEs |
| 11 | Who is the top customer in each country? | `ROW_NUMBER() OVER (PARTITION BY ...)` |

## Run it

The database is a PostgreSQL dump, so restore it with `pg_restore`, not `psql`:

```bash
createdb music_store
pg_restore --no-owner -d music_store music_store_database.dump
psql -d music_store -f analysis_queries.sql
```

## Credit

The dataset and question set come from [Rishabh Mishra's SQL project tutorial](https://youtu.be/VFIuIjswMKM). The queries, the extra findings (revenue concentration, genre share) and the product takeaways are my own.
