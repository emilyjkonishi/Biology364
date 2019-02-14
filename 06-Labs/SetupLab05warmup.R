### Jellybeans!

acne <- data.frame(round(rnorm(200,10,5)))
names(acne) = c("Score")
acne$Group <- c(rep("control", each=100), rep("jellybeans", each=100))

t.test(Score ~ Group, data = acne)

jellybeans = c("control","purple","brown","pink","blue","teal",
               "salmon","red","turquoise","magenta","yellow",
               "grey","tan","cyan","mauve","beige",
               "green","lilac","black","peach","orange")

acne2 <- data.frame(round(rnorm(210,10,5)))
names(acne2) = c("Score")
acne2$Color <- c(rep(jellybeans, each=10))

library(dplyr)

t.test(Score ~ Color, data = filter(acne2, Color == "control" | Color == "purple"))
t.test(Score ~ Color, data = filter(acne2, Color == "control" | Color == "brown"))
t.test(Score ~ Color, data = filter(acne2, Color == "control" | Color == "pink"))
t.test(Score ~ Color, data = filter(acne2, Color == "control" | Color == "blue"))
t.test(Score ~ Color, data = filter(acne2, Color == "control" | Color == "teal"))
t.test(Score ~ Color, data = filter(acne2, Color == "control" | Color == "salmon"))
t.test(Score ~ Color, data = filter(acne2, Color == "control" | Color == "red"))
t.test(Score ~ Color, data = filter(acne2, Color == "control" | Color == "turquoise"))
t.test(Score ~ Color, data = filter(acne2, Color == "control" | Color == "magenta"))
t.test(Score ~ Color, data = filter(acne2, Color == "control" | Color == "yellow"))
t.test(Score ~ Color, data = filter(acne2, Color == "control" | Color == "grey"))
t.test(Score ~ Color, data = filter(acne2, Color == "control" | Color == "tan"))
t.test(Score ~ Color, data = filter(acne2, Color == "control" | Color == "cyan"))
t.test(Score ~ Color, data = filter(acne2, Color == "control" | Color == "green"))
t.test(Score ~ Color, data = filter(acne2, Color == "control" | Color == "mauve"))
t.test(Score ~ Color, data = filter(acne2, Color == "control" | Color == "beige"))
t.test(Score ~ Color, data = filter(acne2, Color == "control" | Color == "lilac"))
t.test(Score ~ Color, data = filter(acne2, Color == "control" | Color == "black"))
t.test(Score ~ Color, data = filter(acne2, Color == "control" | Color == "peach"))
t.test(Score ~ Color, data = filter(acne2, Color == "control" | Color == "orange"))

# Whoa!
ggplot(filter(acne2, Color == "control" | Color == "green"), aes(x=Color, y=Score)) + 
  geom_boxplot()

write.csv(acne, file="acne.csv")
write.csv(acne2, file="acne2.csv")
