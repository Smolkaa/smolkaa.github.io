quarto render _presentation.qmd

robocopy "_presentation_files/" "../../../docs/manuals/tsu_seminar/presentation/_presentation_files/" /e
copy "tum.png" "../../../docs/manuals/tsu_seminar/presentation/"
copy "_style.css" "../../../docs/manuals/tsu_seminar/presentation/"
copy "_presentation.html" "../../../docs/manuals/tsu_seminar/presentation/"

robocopy "../imgs" "../../../docs/manuals/tsu_seminar/imgs" /e