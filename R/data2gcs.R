data2gcs <- function(my_data,my_file_name,my_bucket,my_metadata, chunk_size=100000) {
  #' @title Store data as collection of zipped json files on cloud storage
  #' @description  Split a dataset into many small json files and upload to a
  #'     bucket. All files generated in as part of the function call will
  #'     contain the same generated UUID value
  #' @import googleCloudStorageR
  #' @import assertthat
  #' @import uuid
  #' @import bigrquery
  #' @import readr
  #' @param my_data Dataset to upload to gcs. It must pass a validation test
  #' @param my_file_name Main name for each json file
  #' @param my_metadata List of metadata to be associated with the uploaded files
  #' @param bucket Bucket to store the files in
  #' @param chunk_size Number of rows per json file, ideally <5mb per file
  #' @seealso  \url{https://github.com/cloudyr/googleCloudStorageR}
  #' @export


  ### Test that column names only contain numbers, letters or underscores
  ### query: Invalid field name "Source Database".
  ### Fields must contain only letters, numbers, and underscores, start with a
  ### letter or underscore, and be at most 128 characters long.
  ### Table: test2_ev_tk7esvZiCR4g7BFDkMXxnBs01vvW03jpVdLmV9sioEs_source


  assert_that(nrow(my_data)>0,msg = "Input data frame doesn't contain any rows")

  d <- 1:nrow(my_data)
  chunks <- split(d, ceiling(seq_along(d) / chunk_size))
  x <- list()
  y <- list()
  my_json_name <- list()
  # ensure files are unique from this run
  file_pattern <- paste0(my_file_name, "_", UUIDgenerate(), "_")

  cat("Preparing temporary json files for uploading\n")
  pb <- txtProgressBar(min = 1,
                       max = length(chunks),
                       style = 3)

  for (i in seq_along(chunks)) {
    x[i] <- bigrquery:::export_json(my_data[chunks[[i]],])
    y[i] <- gsub("\n$", "", x[[i]])
    my_json_name[i] <-
      tempfile(pattern = file_pattern, fileext = ".json.gz")
    write_lines(y[[i]], path = my_json_name[[i]])
    setTxtProgressBar(pb, i)
  }

  cat("Done: Files prepared\n")

  files <- list.files(tempdir(), pattern = file_pattern)
  upload_details<-list()

  pb <- txtProgressBar(min = 0,
                       max = length(files),
                       style = 3)
  for (i in seq_along(files)) {
    meta <- gcs_metadata_object(files[i],
                                metadata = my_metadata)
    my_filename <- paste0(tempdir(), "/", files[i])
    upload_details[[i]] <-
      gcs_upload(my_filename,
                 bucket = my_bucket,
                 object_metadata = meta)
    setTxtProgressBar(pb, i)
  }

  return(upload_details)
}
