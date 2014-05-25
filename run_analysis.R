# Exploits file naming convention to read file into data frame easily.
ReadTable <- function(dataset.name, dataset.prefix) {
  prefix <- FilePath(dataset.prefix)
  suffix <- sprintf('%s_%s.txt', dataset.name, dataset.prefix)
  filename <- file.path(prefix, suffix)
  read.table(filename)
}

# Given a file name, read the 2nd column as a string vector
ReadLabels <- function(file.name) {
  read.table(FilePath(file.name), stringsAsFactors=FALSE)[, 2]
}

# Given a file name, generates the full path to the file.
FilePath <- function(file.name) {
  file.path(getwd(), 'UCI HAR Dataset', file.name)
}

# Create a single data frame from multiple files.
MergeFiles <- function() {
  x.test <- ReadTable('X', 'test')
  x.train <- ReadTable('X', 'train')
  x <- rbind(x.test, x.train)

  subject.test <- ReadTable('subject', 'test')
  subject.train <- ReadTable('subject', 'train')
  subject <- rbind(subject.test, subject.train)

  y.test <- ReadTable('y', 'test')
  y.train <- ReadTable('y', 'train')
  y <- rbind(y.test, y.train)
  activity.labels <- ReadLabels('activity_labels.txt')
  y <- factor(y[, 1], labels=activity.labels)

  merged.df <- cbind(x, subject, y)
  features.all <- c(ReadLabels('features.txt'), 'subject', 'activity')
  names(merged.df) <- features.all

  features.mean <- features.all[grep('mean\\(\\)', features.all)]
  features.std <- features.all[grep('std\\(\\)', features.all)]
  features.selected <- c(features.mean, features.std, 'subject', 'activity')

  merged.df[, features.selected]
}

# Writes a tidy data file form a merged data frame
WriteTidyData <- function(df) {
  require(reshape2)
  mdf <- melt(df, id.vars = c('subject', 'activity'))
  tdf <- dcast(mdf, subject + activity ~ variable, mean)
  write.table(tdf, 'tidy_data.txt')
}
