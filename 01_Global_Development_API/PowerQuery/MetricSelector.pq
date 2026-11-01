let
 Source=Csv.Document(Binary.FromText("TWV0cmljCkxpZmUgZXhwZWN0YW5jeQpHRFAgUFBQIHBlciBjYXBpdGEKVW5lbXBsb3ltZW50IHJhdGUK",BinaryEncoding.Base64),[Delimiter=",",Encoding=65001,QuoteStyle=QuoteStyle.Csv]),
 Headers=Table.PromoteHeaders(Source,[PromoteAllScalars=true]),
 Nulls=Table.ReplaceValue(Headers,"",null,Replacer.ReplaceValue,Table.ColumnNames(Headers)),
 Typed=Table.TransformColumnTypes(Nulls,{{"Metric",type text}},"en-US")
in Typed