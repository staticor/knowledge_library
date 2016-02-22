
### R相似标题聚类

aa<-read.csv("e:/aa.csv")
aa$tag<-rep(1:nrow(aa))
library(tm)
library(Rwordseg)
wordsegment<-function(x){
segmentCN(x)
}
title<-as.character(aa$title)
word<-lapply(title,wordsegment)

word_union<-word[[1]]

for (i in 2:length(word)){
	ww<-word[[i]]
	word_union<-union(word_union,ww)

}

mat<-matrix(0,length(word),length(word_union))

for (i in 1:length(word)){
	for(j in 1:length(word[[i]])){
		for (k in 1:length(word_union)){
			if (word[[i]][j] == word_union[k]){
				mat[i,k]<-1
			}
		}
	}

}

mat_t<-t(mat)
mat_cor<-cor(mat_t)
len1<-nrow(mat_cor)-1
len2<-nrow(mat_cor)
for(i in 1:len1){
	n<-i+1
	for(j in n:len2){
		if(aa$tag[j] == j){
		if (mat_cor[i,j]>=0.5){
			aa$tag[j]<-i
		}
	}
	}
}#############


### 全文内容突出

comment<-read.csv("e:/comment.csv")
mystopwords<-read.table("e:/StopWords.txt")
library(tm)
library(Rwordseg)
library(wordcloud)

insertWords(c("黄渤","陈坤","摸金范","特效","3D","鬼吹灯","胡八一","舒淇","彼岸花","乌尔善"))


comment<-as.character(comment$comment)
wordsegment<-function(x){
segmentCN(x)
}#

word<-lapply(comment,wordsegment)

removeStopWords <- function(x,stopwords) {
temp <- character(0)
index <- 1
xLen <- length(x)
while (index <= xLen) {
if (length(stopwords[stopwords==x[index]]) <1)
temp<- c(temp,x[index])
index <- index +1
}
temp
}

word <-lapply(word,removeStopWords,mystopwords)

var<-word[[1]]
for (i in 2:length(word)){
	var<-c(var,word[[i]])
}

data<-data.frame(var,1)
data<-aggregate(data$X1,by=list(data$var),FUN="sum")
name<-data$Group.1
freq<-data$x
wordcloud(name,freq,colors = rainbow(100),scale=c(3,0.5))
