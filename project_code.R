# Importing the dataset
automobiles = read.csv("C:\\Users\\moham\\Downloads\\automobile.csv")
attach(automobiles)

###############################################
############### Data Preprocessing ############
###############################################
##### 1. Missing Values #####

#missing values are represented as ?
#replace ? with NA
automobiles[automobiles == "?"] <- NA
sapply(automobiles, function(x) sum(is.na(x)))

#print percentage of missing data in each column
sapply(automobiles, function(x) sum(is.na(x))/length(x)*100)

#normalized columns has 41 missing points, 20% missing, so remove column
automobiles$normalized.losses <- NULL

#############
##### 2. Exploratory Data Analysis #####
#############

automobiles$price <- as.integer(automobiles$price)
automobiles$peak.rpm <- as.integer(automobiles$peak.rpm)
automobiles$horsepower <- as.integer(automobiles$horsepower)
automobiles$stroke <- as.double(automobiles$stroke)
automobiles$bore <- as.double(automobiles$bore)

#going through all columns
#1. make
boxplot(symboling~make, data = automobiles, main = "Safety vs Make", xlab = "Make", ylab = "Safety")
# the brand of cars does play a bias in the safety score -> alfa romero averages at 3 meaning very risky while
# volvo averages at -1 meaning safe, while some other brands have cars in both regions

#2. fuel.type
boxplot(symboling~fuel.type, data = automobiles, main = "Safety vs Fuel Type", xlab = "Fuel Type", ylab = "Safety")
# gas cars are more risky than diesel cars where gas cars fall in range of 0 to 2 in box
#table(fuel.type)
# only 20 diesel cars and 185 gas...should I remove?

#3. aspiration
boxplot(symboling~aspiration, data = automobiles, main = "Vehicle Aspiration V Risk Rating ", xlab = "Aspiration", ylab = "Risk Rating")
# box plots are nearly identical, so the aspiration of the car does not play a role in the safety score

#4. num.of.doors
boxplot(symboling~num.of.doors, data = automobiles, main = "Safety vs Number of Doors", xlab = "Number of Doors", ylab = "Safety")
# two doors are much riskier than four doors as two doors are usually the exotic sports cars

#5. body.style
boxplot(symboling~body.style, data = automobiles, main = "Safety vs Body Style", xlab = "Body Style", ylab = "Safety")
#convertables are the riskiest while wagons are the safest
#table(body.style)

#6. drive.wheels
boxplot(symboling~drive.wheels, data = automobiles, main = "Safety vs Drive Wheels", xlab = "Drive Wheels", ylab = "Safety")
#table(drive.wheels)
# fwd and rwd have nearly identical boxes with the same safety margin, while 4wd is safer
# as those tend to be the large SUVs
# but only 9 4wd cars, so should I remove?
#table(drive.wheels, make)

#7. engine.location
boxplot(symboling~engine.location, data = automobiles, main = "Safety vs Engine Location", xlab = "Engine Location", ylab = "Safety")
# rear are all at very risky at 3, as they tend to be the sports cars
# count of rear engines and car makes
#table(engine.location, make)
# there are only 3 rear vehicles which are porche, so remove for mulicollinearity

#8. wheel.base
boxplot(wheel.base, data = automobiles, main = "Wheel Base", xlab = "Wheel Base", ylab = "Frequency")

#9. engine.type
boxplot(symboling~engine.type, data = automobiles, main = "Safety vs Engine Type", xlab = "Engine Type", ylab = "Safety")
# ohc and ohcf are the most risky, while ohcv and dohc are the safest

#10. num.of.cylinders
boxplot(symboling~num.of.cylinders, data = automobiles, main = "Safety vs Number of Cylinders", xlab = "Number of Cylinders", ylab = "Safety")
# two and six cylinders are the riskiest

#11. engine.size
boxplot(engine.size, data = automobiles, main = "Engine Size", xlab = "Engine Size", ylab = "Frequency")
#some outliers of engine size

#12. fuel.system
boxplot(symboling~fuel.system, data = automobiles, main = "Safety vs Fuel System", xlab = "Fuel System", ylab = "Safety")
#spdi and 4bbl are the riskiest

#13. symboling
#table(symboling)
#table(symboling, make)
#symboling -2 only in 3 instances in volvo cars, remove those 3 instances for class imbalance
hist((automobiles$symboling), main = "Risk Score Distribution", xlab = "Risk Score", ylab = "Frequency")
#13. price
scatter.smooth(x = price, y = (automobiles$symboling), main = "Price vs Risk Rating", xlab = "Price ($)", ylab = "Risk Rating")
#no clear correlation between price and safety

boxplot(automobiles$price, data = automobiles, main = "Vehicle Price Distribution",  ylab = "Price ($)")
hist(automobiles$price, data = automobiles, ylab = 'Frequency',xlab = "Price ($)", main = "Histogram of Vehicle Prices")



############
##### 3. Removing Unnecessary Columns and rows #####
############

# remove columns identified in eda
automobiles$engine.location <- NULL
automobiles$aspiration <- NULL
automobiles$fuel.type <- NULL
#drive.wheels

#remove rows where symboling = -2
automobiles <- automobiles[automobiles$symboling != -2,]

#remove na
automobiles <- na.omit(automobiles)




############
##### 4. Categorical Variables #####
############

# convert all binary categories to 0 and 1
#fuel.type = 1 = gas, 0- diesel
#automobiles$fuel.type <- ifelse(automobiles$fuel.type == "gas", 1, 0)

#aspiration = 0 = std, 1 = turbo
#automobiles$aspiration <- ifelse(automobiles$aspiration == "std", 0, 1)

#num.of.doors => 4 = four doors, 2 = two doors
automobiles$num.of.doors <- ifelse(automobiles$num.of.doors == "four", 4, 2)

#engine.location = 0 = front, 1 = rear
#automobiles$engine.location <- ifelse(automobiles$engine.location == "front", 0, 1)

#num.of.cylinders => 4 = four cylinders, 6 = six cylinders, 5 = five cylinders, 8 = eight cylinders, 3 = three cylinders, 12 = twelve cylinders, 2 = two cylinders
automobiles$num.of.cylinders <- ifelse(automobiles$num.of.cylinders == "four", 4, ifelse(automobiles$num.of.cylinders == "six", 6, ifelse(automobiles$num.of.cylinders == "five", 5, ifelse(automobiles$num.of.cylinders == "eight", 8, ifelse(automobiles$num.of.cylinders == "three", 3, ifelse(automobiles$num.of.cylinders == "twelve", 12, 2))))))

#factor the rest
categorical_variables <- sapply(automobiles, is.character)
for (i in names(automobiles)[categorical_variables]) {
  automobiles[,i] <- factor(automobiles[,i])
}

############
##### 5. Checking Multicollinearity #####
############
#correlation matrix
numeric_columns <- sapply(automobiles, is.numeric)
#get correlation matrix with nimeric columns
cor(automobiles[,numeric_columns])

library(corrplot)
corrplot(cor(automobiles[,numeric_columns]), method = "circle")


#get all numeric columns except symboling
numeric_columns <- sapply(automobiles, is.numeric)
numeric_columns <- names(numeric_columns)[numeric_columns]
numeric_columns <- numeric_columns[numeric_columns != "symboling"]


library(car)


#very strong multicollinearity in some columns, remove them
#remove engine.size, width, city.mpg

nums <- numeric_columns[!numeric_columns %in% c('curb.weight',"width","horsepower",'city.mpg','engine.size','highway.mpg')]
lm_model <- lm(symboling ~ ., data = automobiles[, c("symboling", nums)])
vif(lm_model)
cor(automobiles[,nums])

#removing columns
to_remove <- c('curb.weight',"width","horsepower",'city.mpg','engine.size','highway.mpg')
for (col in to_remove){
  automobiles[,col] <- NULL
}

############
##### 6. Outliers #####
############
reg = lm(symboling ~ ., data = automobiles)
outlierTest(reg)
#remove outlier point 89
automobiles <- automobiles[-89,]



###############################################
############### The Classification ############
###############################################
library(MASS)
library(klaR)
library(caret)
library(tree)
library(rpart)
library(rpart.plot)

#train test split
automobiles$symboling = as.factor(automobiles$symboling)
set.seed(37)
train_index <- sample(1:nrow(automobiles), 0.84*nrow(automobiles))
train <- automobiles[train_index,]
test <- automobiles[-train_index,]

#print number of unique values in symboling and their counts
table(train$symboling)
table(test$symboling)


###########
# 1. LDA 
###########
mylda = lda(symboling ~ ., data = train)
#partimat(symboling ~ ., data = train, method = "lda", image.colors = c("light grey", "light green", "white", 'light blue', 'red'))

#confusion matrix
pred = predict(mylda, test)
table(pred$class, test$symboling)
#accuracy score
mean(pred$class == test$symboling) #77.42%
confusionMatrix(table(pred$class, test$symboling))


###########
# 2. Decision Tree
###########
myoverfittedtree=rpart(symboling ~ ., data = train, control = rpart.control(cp = 0.001))
rpart.plot(myoverfittedtree)

printcp(myoverfittedtree)
plotcp(myoverfittedtree)
opt_cp=myoverfittedtree$cptable[which.min(myoverfittedtree$cptable[,"xerror"]),"CP"]

bestTree = rpart(symboling ~ ., data = train, control = rpart.control(cp = opt_cp))
pred = predict(bestTree, test) 
predicted_labels = colnames(pred)[max.col(pred, "first")]
#accuracy score
mean(predicted_labels == test$symboling) #54.8%
confusionMatrix(table(predicted_labels, test$symboling))

###########
# 3. Random Forest
###########
library(randomForest)

myforest=randomForest(symboling ~ ., data = train,
                      ntree=2000, importance=TRUE, na.action = na.omit, do.trace = 100)


#best one was 500 trees
myforest=randomForest(symboling ~ ., data = train,
                      ntree=500, importance=TRUE, na.action = na.omit)
pred = predict(myforest, test)
print(mean(pred == test$symboling) ) #83.9%
confusionMatrix(table(pred, test$symboling))

#creating a heatmap

conf_matrix <- table(pred, test$symboling)
conf_df <- as.data.frame.matrix(conf_matrix)
conf_df <- data.frame(
  Actual = rep(rownames(conf_df), each = ncol(conf_df)),
  Predicted = rep(colnames(conf_df), times = nrow(conf_df)),
  Frequency = c(conf_matrix)
)
library(ggplot2)

ggplot(data = conf_df, aes(x = Predicted, y = Actual, fill = Frequency)) +
  geom_tile(color = "white") +
  geom_text(aes(label = Frequency), vjust = 0.5) +
  theme_minimal() +
  scale_fill_gradient(low = "white", high = "red") +
  labs(title = "Random Forest Test Set Confusion Matrix",
       x = "Predicted",
       y = "Actual",
       fill = "Frequency")+
  theme(
    panel.grid.minor = element_line(color = "black", size = 0.5),
    panel.border = element_rect(color = "black", fill = NA, size = 1)
  )

###########
# 4. Boosting
###########
library(gbm)

gbmGrid <-  expand.grid(interaction.depth = c(1, 5, 9,12), 
                        n.trees = c(100, 500, 1000, 3000,5000,70000,10000), 
                        shrinkage = c(0.01,0.1,0.4,0.7,0.9),
                        n.minobsinnode = c(10,20,50)
)


set.seed(88)

fitControl <- trainControl(## 10-fold CV
  method = "repeatedcv",
  number = 5,
  ## repeated ten times
  repeats = 2)

gbmFit2 <- train(symboling ~ ., data = automobiles, 
                 method = "gbm", 
                 trControl = fitControl, 
                 verbose = FALSE, 
                 ## Now specify the exact models 
                 ## to evaluate:
                 tuneGrid = gbmGrid)
gbmFit2

gbmGrid <-  expand.grid(interaction.depth = 12, 
                        n.trees = 500, 
                        shrinkage = 0.1,
                        n.minobsinnode = 10)
#12,500,0.1,10 -> 82.1%

gbmFit2 <- train(symboling ~ ., data = train, 
                 method = "gbm", 
                 verbose = FALSE, 
                 ## Now specify the exact models 
                 ## to evaluate:
                 tuneGrid = gbmGrid)
test_pred = predict(gbmFit2, test)
#accuracy score
mean(test_pred == test$symboling)
confusionMatrix(table(test_pred, test$symboling))



###############################################
############### The Clustering  ###############
###############################################
##getting feature importances
library(randomForest)
myforest=randomForest(symboling ~ ., data = automobiles,
                      ntree=500, importance=TRUE, na.action = na.omit)
myforest
importance(myforest)
varImpPlot(myforest, type = 1, main = "Random Forest Feature Importance for Insurance Risk Rating")

automobiles$symboling = as.numeric(automobiles$symboling)
# make, wheel.base, length, num.of.doors, height, bore, price, peak.rpm, stroke,body.style
clusterdf = automobiles[,c('symboling','make','body.style','wheel.base', 'length', 'num.of.doors', 'height', 'bore', 'price', 'peak.rpm', 'stroke')]


#standardize
columns_to_scale <- c('symboling','wheel.base', 'length', 'num.of.doors', 'height', 'bore', 'price', 'peak.rpm', 'stroke')
cluster_og = clusterdf
clusterdf[, columns_to_scale] <- scale(clusterdf[, columns_to_scale])
dummy_model = dummyVars(~., data = clusterdf)
dummy_clusterdf = predict(dummy_model, newdata = clusterdf)

#kmeans
library(factoextra)
#elbow method
fviz_nbclust(dummy_clusterdf, kmeans, method = "wss") +
  ggtitle("Elbow Method for K-Means") +
  theme(plot.title = element_text(hjust = 0.5))
#silhouette method
fviz_nbclust(dummy_clusterdf, kmeans, method = "silhouette")+
  ggtitle("Silhouette Score for K-Means") +
  theme(plot.title = element_text(hjust = 0.5))



#find sillhouette score of 4 clusters
library(cluster)
kmeans(dummy_clusterdf, 4) -> kfit
silhouette(kfit$cluster, dist(dummy_clusterdf)) -> avg_sil_width



kfit = kmeans(dummy_clusterdf, 4)

#plotting
library(cluster)
clusplot(dummy_clusterdf, kfit$cluster, color = TRUE, shade = TRUE,
         labels = 4, lines = 0, plotchar = FALSE, span = TRUE,
         main = "PCA Reduced Cluster Plot for K-Means")

## getting characteristics
cluster_og$Cluster <- kfit$cluster

summary_stats <- function(x) { 
  c(Min = min(x),
    Max = max(x),
    Q25 = quantile(x, 0.25),
    Median = median(x),
    Mean = mean(x),
    Mode = as.numeric(names(sort(table(x), decreasing = TRUE)[1])))
}

numeric <- c('Cluster','symboling','wheel.base', 'length', 'num.of.doors', 'height', 'bore', 'price', 'peak.rpm', 'stroke')
cluster_og$make <- as.factor(cluster_og$make)
cluster_og$body.style <- as.factor(cluster_og$body.style)
aggregate(. ~ Cluster, cluster_og[,numeric], summary_stats)
categ <- c('make','body.style')
for (i in c(1:4)){
  spec = cluster_og[cluster_og$Cluster == i,]
  print(paste("Cluster",i))
  print(summary(spec[,categ]))
  #print mode of symboling in spec
  print(mode(spec$symboling))
}











