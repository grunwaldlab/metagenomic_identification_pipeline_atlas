## Metagenomic pipeline comparison

This is a review of all existing automated pipelines that incorperate the identification of organisms from shotgun metagenomic data.

Pipeline features needed to be included in the review:
- Accepts shotgun metagenomic data (e.g., not only metabarcoding or other genetic data)
- Does not require the user to specify the target organism
- Is not restricted to a narrow group of organisms (e.g. something specific to bacteria is fine, but something specific to a family/genus/species is not)
- Is open source
- If it uses any web-based resources/API for metagenomic based organism identification, they must be publically available without a API key or user account


Make a table of the following information for each pipeline:
- License
- Developing lab/oranization
- Citation (if exists)
- Year first released
- source code link (e.g. github)
- Development status (e.g. active, abandoned, etc)
- The taxa the pipeline is intended to identify
- The taxa the pipeline is capable of identifying
- If the pipeline outputs an HTML/PDF report summarizing results. If so, what tool is used to make the report (e.g. MULTIQC, quarto, etc)
- A list of the core tools used for metagenomic organisms identification
- A summary of how the tools are used to identify organisms from metagenomic data
- How much RAM, CPU-hours, and diskspace (for both databases and analysis results) is required to analyse a typical sample targeting a type of organism in a metagenomic context (if applicable to the pipeline):
  - Viruses
  - Bacteria
  - Archea
  - Fungi
  - Plants
  - Animals
  - Protists
- Any other information that seems relevant

Based on the above data and any other considerations, group pipelines into those with similar feature sets, focusing on the core tools and general strategy used for identification of organisms from metagenomic data and their target taxa.

## How to format this output

General intructions:
- Convert the above information into machine-readable files and markdown files as appropriate to the data type and display them as an HTML dashboard/wesbite using Quarto.
- Use multi-tab single-page dashboards or multiple pages or both as appropriate to the data being displayed.
- The resulting source code for the site should be editable and extendable in a text editor or spreadsheet editor.
- Make the width of the dashboards/tables fill the user's screen, but limit the width of blocks of text to a readable standard
- No hero image or attention getting gimmiks, this is for internal use
- No dark mode or reader mode
- The width of wide tables/dashboards should fill the user's browser horizontal space and not be constrained by a typical website's page width if that allows them to avoild horizontal scrolling.
- Tables should show up to 100 entries by default
- References should be linked to their primary reference on the internet
- Tables should have equal height rows, but not nescessarily limted to a single line of text
- Columns with quantatitative or orederable qualitative categories, should be color coded and sortable by the underlying metric even if displaying arbitrary text.

Website layout:

One page for each of:
- Overview (home):
 - The criteria used to include pipelines
 - Summary stats on number of pipelines and tools considered
 - Date last modified
 - How to modify the raw data
 - How the website is constructed
 - Hot the raw data is constructed
 - Near misses and exclusions
- Pipelines: One row per pipeline with general information:
  - Name
  - Developing group
  - Status
  - strategy
  - Core tools
  - Reports
  - Source
  - Reference
  - License
  - Notes
- Tools: One tool per row with, sorted by number of p ipelines using it, at least the following info:
  - tool name
  - tool purpose
  - Number of pipelines using it
  - List of pipelines that use it 
  - source code URL
  - citation URL
  - RAM requirements range: Should display text summary, but be sorteable by the max of the range, which is also used to color background of cell
  - relative speed: should be color-coded background, sortable by their meaning, not label (e.g. low, medium, high)
  - diskspace range needed for databases: Should display text summary, but be sorteable by the max of the range, which is also used to color background of cell
  - diskspace range needed for samples: same treatment as database diskspace
- Taxa: table with one row per pipeline, sorted by score by default, with at least:
  - pipeline name
  - intended scope
  - Score: A relative metric that takes into account how many groups are supported, with intended support contributing more than DB-based. Render as colored bars.
  - One column for each of Bacteria, Archea, Viruses, Fungi, Plants, Animals, Protists
  - Notes
- Resources: table with one row per pipeline, sorted by score by default, with at least:
 - pipeline name
  - Score: A relative metric that takes into account RAM, speed, and database requirements. 
  - RAM requirements range: Should display text summary, but be sorteable by the max of the range, which is also used to color background of cell
  - relative speed: should be color-coded background, sortable by their meaning, not label (e.g. low, medium, high)
  - diskspace range needed for databases: Should display text summary, but be sorteable by the max of the range, which is also used to color background of cell
  - diskspace range needed for samples: same treatment as database diskspace
- Strategies
 - A text summary of each groupings of similar stratagies with lists of pipelines in each group. 
 - A PCA or equvialten dimensilaity reduction scatter plot with one dot per pipeline based on a table compiled of tools used, supported taxa, and general methods.
  Color dots by identified groupings of similar stratagies. 
 - A interactive interaction network graph with one dot per tool and lines showing associations between tools that indictaion co-occurance. Tools that tend to be used together should naturally cluster.
