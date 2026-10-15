# Shotgun Pipeline Atlas

A multi-page Quarto website for the sourced comparison in [`pipeline_review.md`](pipeline_review.md).

## Build

Requirements:

- Quarto 1.5 or newer
- R 4.1 or newer
- R packages `knitr` and `DT`

Render from this directory:

```sh
quarto render
```

Preview locally with:

```sh
quarto preview
```

The static site is written to `_site/`. The generated files are reproducible outputs and are ignored by Git; edit the `.qmd`, CSV, and CSS source files instead.

## Edit the content

- Edit the dashboard data in [`data/`](data/README.md). CSV files open in Excel, LibreOffice, and text editors.
- Use `tools.csv` to maintain one metadata row per tool and `pipeline_tools.csv` to link tools to workflows and stages.
- Edit page layout and text in the `.qmd` files.
- The relative taxon breadth score is defined in `R/taxon_score.R` and documented on the Taxa page.
- Edit visual styling in `styles.css`.
- Keep `pipeline_review.md` as the detailed evidence/research note in the source folder. The site presents screening boundaries on Overview and strategy synthesis on Strategies.
- After editing CSVs, run `quarto render` to rebuild all pages and interactive tables.

Overview contains the screening criteria, summary counts, source-data/site construction notes, and exclusions. Pipeline catalogue, tools, taxa, resources, and strategy visualizations have dedicated pages.
