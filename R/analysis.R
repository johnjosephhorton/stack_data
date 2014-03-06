library(RSQLite)
library(ggplot2)


db.path <- "../sqlite/so-dump.db"
con <- dbConnect(dbDriver("SQLite"), dbname = db.path)


query <- "select ViewCount, Score, CommentCount, AnswerCount from Posts"
df.raw <- dbGetQuery(con, query)

df <- df.raw

m <- lm(AnswerCount ~ ViewCount, data = df)
m <- lm(CommentCount ~ ViewCount, data = df)
m <- lm(Score ~ CommentCount, data = df)



g <- ggplot(data = df, aes(x = ViewCount, y = Score)) +
    geom_point() + geom_smooth() 

png("example_plot.png")
print(g)
dev.off()

summary(df)
