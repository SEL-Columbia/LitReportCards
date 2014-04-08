###########
## Step 1: Download the data, and write out raw download files
###########
require(formhub)
sub <- data.frame(name="_submission_time", type="datetime", label="Submission Time", stringsAsFactors=F)
teachers <- formhubDownload("TeacherRegistration_Bonsaaso_Oct23", uname="litreportcards", 
                            extraFormDF=sub, authfile="litauth.pwd")
saveRDS(teachers, "data/Teachers_raw.rds")
learningdata <- formhubDownload("LiteracyAssessment_Bonsaaso_2014_Feb26", uname="litreportcards", 
                                extraFormDF=sub, authfile="litauth.pwd")
saveRDS(learningdata, "data/Learning_raw.rds")

###########
## Step 2: Pull in Teachers Control data, check for congruence
###########
t <- read.csv("data//TeachersControl.csv", stringsAsFactors=FALSE)
row.names(t) <- t$teacher_fallback_ID
stopifnot(nrow(subset(as.data.frame(learningdata), 
    !teacher_fallback_ID %in% t$teacher_fallback_ID & teacher_fallback_ID != "")) == 0)

###########
## Step 3: Merge. Drop unofficial assessment and bad scans.
###########
## Pull in full barcode from teacher if missing
learningdata$teacher_barcode <- ifelse(learningdata$teacher_barcode != "", 
           as.character(learningdata$teacher_barcode), 
           t[learningdata$teacher_fallback_ID, 'teacher_barcode'])
## Drop unnecessary data
learningdata <- subset(as.data.frame(learningdata), official_assessment == 'Yes',
                       select=c("teacher_barcode", "age", "sex","literacy_level", 
                                "official_assessment", "X_submission_time"))
## Drop bad scans
num_all_observations <- nrow(learningdata)
learningdata <- subset(learningdata, teacher_barcode %in% t$teacher_barcode |
                           teacher_barcode == "")
cat("DROPPING", num_all_observations - nrow(learningdata), " OBS with BAD SCANS.\n")
## Standardize barcode
learningdata <- merge(t, learningdata, by='teacher_barcode')

###########
## Step 4: Re-order the literacy levels, calculate "group".
###########
reading_levels <- c("Nothing", "Letters", "Words", "Paragraphs", "Story")
learningdata$literacy_level <- factor(learningdata$literacy_level, reading_levels)
learningdata$Group <- sprintf("%s, %s group", learningdata$grade, learningdata$treat)

###########
## Step 5: Add "phase" information
###########
iso8601DateTimeConvert <- function(x) { ymd_hms(str_extract(x, '^[^+Z]*(T| )[^+Z-]*')) }
learningdata$X_submission_time <- iso8601DateTimeConvert(learningdata$X_submission_time)
phasemap <- c("2014-03-09"="Baseline", "2014-04-06"="Midline 1")
learningdata$Phase <- phasemap[as.character(round_date(learningdata$X_submission_time, 'week'))]

###########
## Step 6: Save
###########
saveRDS(learningdata, "data/Learning_processed.RDS")
