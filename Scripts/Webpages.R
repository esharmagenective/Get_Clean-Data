con = url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
htmlCode=readLines(con)
close(con)
htmlCode

library(XML)
library(httr)
html2=GET("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
content2=content(html2,as="text")
parsedHtml=htmlParse(content2, asText=TRUE)
xpathSApply(parsedHtml,"//title",xmlValue)

