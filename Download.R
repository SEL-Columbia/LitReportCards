require(formhub)
teachers <- formhubDownload("TeacherRegistration_Bonsaaso_Oct23", uname="litreportcards", pass=
                                changeTHIS)
saveRDS(teachers, "data/Teachers.rds")
learningdata <- formhubDownload("LiteracyAssessment_Bonsaaso_2014_Feb26", uname="litreportcards", pass=
                                changeTHIS)
saveRDS(learningdata, "data/Learning.rds")
