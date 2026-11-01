# SQL Murder Mystery

**The brief:** a murder happened in SQL City on 15 January 2018. All you have is a database of people, interviews, gym records, licences and event check-ins. Find the killer, and whoever hired them.

It's a well-known public puzzle ([Knight Lab's SQL Murder Mystery](https://mystery.knightlab.com/)). I've included it because it practises a core PM habit: turning a vague problem into small questions, each one checkable before taking the next step.

## How I narrowed it down

| Step | Question | Query | Finding |
|---|---|---|---|
| 1 | What does the crime-scene report say? | [query](./queries/step1_crime_scene_report.sql) | [Two witnesses](./results/step1_crime_scene_report.md): one on Northwestern Dr, one named Annabel on Franklin Ave |
| 2 | Who are the witnesses? | [query](./queries/step2_find_witnesses.sql) | [Morty Schapiro and Annabel Miller](./results/step2_witnesses.md) |
| 3 | What did they see? | [query](./queries/step3_witness_interviews.sql) | [Gold gym member, ID starting 48Z, plate containing H42W](./results/step3_witness_interviews.md) |
| 4 | Who matches every clue? | [query](./queries/step4_identify_killer.sql) | [Jeremy Bowers](./results/step4_killer.md) |
| 5 | Who hired him? | [query](./queries/step5_identify_mastermind.sql) | [Miranda Priestly](./results/step5_mastermind.md) |

The step 4 query joins four filtered sets (gym check-ins, gold members, people, licence plates) in one pass, so only someone who matches every clue survives.

## Run it

The database lives on the puzzle's site. Paste each query into the SQL console there, in order.
