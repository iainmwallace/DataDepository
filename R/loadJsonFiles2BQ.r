loadJsonFiles2BigQuery<-function(
  project,
  dataset,
  table,
  source_uris,
  create_disposition ="CREATE_IF_NEEDED",
  write_disposition = "WRITE_APPEND"
){
  #' @title Load JSON files into a big query table
  #' @description  Load JSONL files that are stored in google cloud storage into
  #' a big query table. Schema will be automatically detected.
  #' @import bigrquery
  #' @param project Google cloud billing project
  #' @param dataset Dataset that contains the table
  #' @param table Table to load the json files into.
  #' @param source_uris Vector containing the GS location of the files to be
  #'      loaded
  #' @seealso  \url{https://github.com/cloudyr/googleCloudStorageR} Files to be
  #'      loaded can be uploaded easily using the cloudyr package
  #' @seealso \url{https://cloud.google.com/bigquery/docs/reference/rest/v2/jobs#configuration.load}
  #'
  #' @export


  url <- bigrquery:::bq_path(project, jobs = "")

  body <- list(
    configuration = list(
      load = list(
        sourceFormat = "NEWLINE_DELIMITED_JSON",
        sourceUris = source_uris,
        autodetect = TRUE,
        destinationTable = list(
          projectId = project,
          datasetId = dataset,
          tableId = table
        ),
        createDisposition = create_disposition,
        writeDisposition = write_disposition
      )
    )
  )


  bigrquery:::bq_post(url, body = bigrquery:::bq_body(body))

}
