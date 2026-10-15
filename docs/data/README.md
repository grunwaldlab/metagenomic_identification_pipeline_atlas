# Data files

These UTF-8 CSV files are the dashboard's editable source data. They can be edited in a text editor or opened in Excel/LibreOffice. Keep the `pipeline_id` stable when changing names, and use exact pipeline IDs when adding rows to related files.

- `pipelines.csv`: one row per qualifying workflow; metadata, intended/capable taxa summary, core tools and identification strategy, report, citation, source, and caveats.
- `tools.csv`: one row per distinct tool, with purpose, source/citation links, approximate resource ranges, and an estimate note.
- `pipeline_tools.csv`: one row per pipeline/tool/stage mapping. `tool_id` joins to `tools.csv`; the website derives each tool's pipeline list and distinct-pipeline count from this table, then sorts by count descending.
- `taxa_matrix.csv`: one row per workflow; capability codes by taxon (`Y`, `DB`, `~`, `—`), intended scope, and intended taxon groups. The Taxa page calculates a weighted breadth score using `R/taxon_score.R`.
- `resources.csv`: one row per workflow; documented requirements and observed timing, with evidence type and context. Use `Not reported` rather than a blank or an inferred value.
- `resource_estimates.csv`: one row per workflow; approximate RAM, database, sample-output, and relative-speed planning ranges for the Resources dashboard. Assumptions are recorded in each row.
- `strategy_groups.csv`: group definitions and member IDs.
- `pipeline_groups.csv`: normalized workflow-to-group mapping.

After editing a CSV, run `quarto render`. The data tables and visualizations on the website are generated from these files. `pipeline_review.md` is retained as a detailed evidence/research note in the source folder; the website surfaces the inclusion criteria and near-misses on Overview and the strategy synthesis/visualizations on Strategies.

For CSV compatibility, preserve the header names, UTF-8 encoding, and standard double-quote escaping. Keep every `tool_id` unique in `tools.csv` and use those IDs in the mapping file. Semicolons separate stages in the `identification_strategy` field. Prefer adding rows to the taxa/resource tables over adding new taxon-specific columns. The Quarto pages use R with the `DT` package to render searchable and sortable HTML tables.
