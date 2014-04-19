# Connect to the DB

library(RSQLite)
library(ggplot2)
library(ineq)

db.path <- "../sqlite/so-dump.db"
con <- dbConnect(dbDriver("SQLite"), dbname = db.path)

getData <- function(tblname){
    dbGetQuery(con, paste0("select * from ", tblname))
}

# 1. Calculate and plot the ecdf of votes per question 

df.Q1 <- getData("Q1")
df.Q1$F <- with(df.Q1, ecdf(votes)(votes))

ggplot(data = df.Q1, aes(x = votes, y = F)) + geom_line() + theme_bw()

# 2. Plot the scatter plot of votes and views per question

df.Q2Data <- getData("Q2Data")

# unscaled version 
ggplot(data = df.Q2Data, aes(x = votes, y = views)) +
    geom_point() +
    geom_smooth() +
    theme_bw()

# scaled version 
ggplot(data = df.Q2Data, aes(x = votes, y = views)) +
    geom_point() +
    geom_smooth() +
    theme_bw() +
    scale_y_log10() + scale_x_log10()

# 3. What is the distribution of elapsed time between posting and comments? 

df.Q3Data <- getData("Q3Data")

summary(df.Q3Data)

# unscaled 
ggplot(data = df.Q3Data, aes(x = ElapsedMins)) + geom_density()

# scaled version 
ggplot(data = df.Q3Data, aes(x = ElapsedMins)) + scale_x_log10() + geom_density() 

# 4. What is the distribution of elapsed time between posts and answers? 

df.Q4Data <- getData("Q4Data")

# convert to hours 
df.Q4Data$ElapsedHours <- with(df.Q4Data, ElapsedMins/60)

ggplot(data = df.Q4Data, aes(x = ElapsedHours)) + scale_x_log10() + geom_density()

## 5. Is the average length of comments correlated with the average length of the post? 

df.Q5 <- getData("Q5Data")

# this probably makes more sense in a regression framework 
m <- lm(log(Length_Comment) ~ log(Length_Post), data = df.Q5)

ggplot(data = df.Q5, aes(x = Length_Comment, y = Length_Post)) + geom_point() +
    scale_x_log10() + scale_y_log10()

## 6. - What is the distribution of questions per user?
##    - Answers per user?
##    - What is the correlation between answers and questions per user? 

## -questions per user

df.Q6a <- getData("Q6Data_a")

ggplot(data = df.Q6a, aes(x = Num_Q)) + geom_density() + scale_x_log10()

# answers per user

df.Q6b <- getData("Q6Data_b")

ggplot(data = df.Q6b, aes(x = Nbr_Ans)) + geom_density() 

#-correlation

df.Q6c <- getData("Q6Data_c")

m <- lm(Nbr_Ans ~ Num_Q, data = df.Q6c)

m.log.scale <- lm(log1p(Nbr_Ans) ~ log1p(Num_Q), data = df.Q6c)

# 7. If we think of answers as “wealth,” what is the gini coefficient of answers per question? 

df.Q7 <- getData("Q7Data")

with(df.Q7, ineq(answers, type = "Gini"))


# 8. Does the hour of the day when a question is asked matter in terms of getting an answer? 

df.Q8 <- getData("Q8Data")

df.Q8$hour <- with(df.Q8, as.numeric(as.character(hour)))

ggplot(data = df.Q8, aes(x = hour, y = avgAns)) + geom_point() + geom_line()


# 9. Does this seem to be any relationship between the tags used and the probability of a question receiving an answer? 


