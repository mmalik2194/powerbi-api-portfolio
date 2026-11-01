let
 Source=Csv.Document(Binary.FromText("UFJQZXJjZW50CjY1CjcwCjc1CjgwCjg1CjkwCg==",BinaryEncoding.Base64),[Delimiter=",",Encoding=65001,QuoteStyle=QuoteStyle.Csv]),
 Headers=Table.PromoteHeaders(Source,[PromoteAllScalars=true]),
 Nulls=Table.ReplaceValue(Headers,"",null,Replacer.ReplaceValue,Table.ColumnNames(Headers)),
 Typed=Table.TransformColumnTypes(Nulls,{{"PRPercent",Int64.Type}},"en-US")
in Typed