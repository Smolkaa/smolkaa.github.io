quarto render _presentation.qmd

robocopy "_presentation_files/" "../../../docs/presentations/tsu_seminar/presentation/_presentation_files/" /e
copy "tum.png" "../../../docs/presentations/tsu_seminar/presentation/"
copy "_style.css" "../../../docs/presentations/tsu_seminar/presentation/"
copy "_presentation.html" "../../../docs/presentations/tsu_seminar/presentation/"

robocopy "../imgs" "../../../docs/presentations/tsu_seminar/imgs" /e