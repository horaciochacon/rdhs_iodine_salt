# Load data for Meta-analysis
library(meta)
library(metafor)
library(ggplot2)

# Usar valores ponderados

dataset <- structure(list(study = c("Bernardi-Daltrozo 2010", "Rodrigues de Freitas 2013", "Oliveira da Silva 2013",
                                    "Bastiani 2014", "Fontenele 2015", "Vidalez-Braz 2015", "Santos 2017",
                                    "Bonfim 2017", "Ribeiro 2017", "Lugon 2018", "Cordeiro 2018", "Miranda de Menezes 2020",
                                    "Miranda de Menezes 2021", "Neukman 2017", "Pereson 2021", "La Rosa-Hernandez 2016", "Kossuth-Cabrejos 2020"),
                          author = c("Bernardi-Daltrozo", "Rodrigues de Freitas", "Oliveira da Silva",
                                     "Bastiani", "Fontenele", "Vidalez-Braz", "Santos",
                                     "Bonfim", "Ribeiro", "Lugon", "Cordeiro", "Miranda de Menezes",
                                     "Miranda de Menezes", "Neukman", "Pereson", "La Rosa-Hernandez", "Kossuth-Cabrejos"), 
                          year = c(2010L, 2013L, 2013L, 2014L, 2015L, 2015L, 2017L, 2017L, 2017L, 2017L, 2018L, 2018L, 2020L, 2021L, 2017L, 2020L, 2016L),
                          tgroup = structure(c(1L, 2L, 3L, 4L, 5L, 6L, 7L, 8L, 9L, 10L, 11L, 12L, 13L, 14L, 15L, 16L, 17L),.Label = c("Brazil","Brazil","Brazil","Brazil","Brazil","Brazil","Brazil","Brazil","Brazil","Brazil","Brazil","Brazil","Brazil","Argentina","Argentina","Cuba","Peru"), class = "factor"), 
                          num = c(6L, 67L, 37L,	66L, 15L, 58L, 19L, 11L, 18L, 572L, 11L, 1361L, 1421L, 463L, 179L, 54L, 81L), 
                          denom = c(103L,798L,159L,649L,301L,318L,605L,188L,143L,21183L,394L,42546L,45852L,1658L,748L,103L,264L)), 
                     datalabel = "", time.stamp = "16 Oct 2021 10:10", 
                     .Names = c("study", "author", "year", "tgroup", "num", "denom"), 
                     formats = c("%20s", "%14s", "%8.0g", "%22.0g", "%9.0g", "%9.0g", "%9.0g", "%9.0g","%20s", "%14s", "%8.0g", "%22.0g", "%9.0g", "%9.0g", "%9.0g"), 
                     types = c(20L, 14L, 252L, 251L, 254L, 254L, 254L, 254L,20L, 14L, 252L, 251L, 254L, 254L, 254L), 
                     val.labels = c("", "", "", "tgroup", "", ""),  
                     row.names = c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17"), version = 19L, label.table = structure(list(
                       tgroup = structure(c(1L, 2L, 3L, 4L, 5L, 6L, 7L, 8L, 9L, 10L, 11L, 12L, 13L, 14L, 15L, 16L, 17L), .Names = c("Brazil","Brazil","Brazil","Brazil","Brazil","Brazil","Brazil","Brazil","Brazil","Brazil","Brazil","Brazil","Brazil","Argentina","Argentina","Cuba","Peru"))), .Names = "tgroup"), class = "data.frame")


# Meta-analysis using a generic random-effects inverse variance method   https://rdrr.io/cran/meta/src/R/metaprop.R    https://htanalyze.com/wp-content/uploads/2018/05/rotina.txt
metaanalysis <- metaprop(event = num, 
                         n= denom, 
                         data=dataset,
                         studlab = study,
                         subgroup = (tgroup),
                         exclude = NULL,
                         method = "Inverse",  ##One of "Inverse" and "GLMM", can be abbreviated
                         sm="PFT",
                         method.ci = "CP",  ##Clopper-Pearson interval also called ’exact’ binomial interval (method.ci = "CP", default)
                         level = 0.95,
                         fixed = FALSE,
                         hakn=F,
                         method.tau="DL")  ##DerSimonian-Laird estimator (method.tau = "DL") Either "DL", "PM", "REML", "ML", "HS", "SJ", "HE", or "EB", can be abbreviated.

metaanalysis

#Forest plot
forest(metaanalysis, comb.fixed = FALSE, 
       bylab = "study subgroup", 
       hetlab = "", print.tau2 = FALSE,
       layout = "RevMan",
       col.square = "red",
       digits = 1,
       digits.I2= 0,
       digits.tau= 3,
       digits.tau2= 3,
       digits.pval = 3,
       pscale = 100,
       xlim=c(0, 70),
       col.square.lines = "red")
