let
 Source=Csv.Document(Binary.FromText("WWVhcgoyMDAwCjIwMDEKMjAwMgoyMDAzCjIwMDQKMjAwNQoyMDA2CjIwMDcKMjAwOAoyMDA5CjIwMTAKMjAxMQoyMDEyCjIwMTMKMjAxNAoyMDE1CjIwMTYKMjAxNwoyMDE4CjIwMTkKMjAyMAoyMDIxCjIwMjIKMjAyMwoyMDI0Cg==",BinaryEncoding.Base64),[Delimiter=",",Encoding=65001,QuoteStyle=QuoteStyle.Csv]),
 Headers=Table.PromoteHeaders(Source,[PromoteAllScalars=true]),
 Nulls=Table.ReplaceValue(Headers,"",null,Replacer.ReplaceValue,Table.ColumnNames(Headers)),
 Typed=Table.TransformColumnTypes(Nulls,{{"Year",Int64.Type}},"en-US")
in Typed