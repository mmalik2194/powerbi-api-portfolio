let
 Source=Csv.Document(Binary.FromText("TW9kZSxSZXRyaWV2ZWQKQVBJIHNuYXBzaG90LDIwMjYtMTEtMDEK",BinaryEncoding.Base64),[Delimiter=",",Encoding=65001,QuoteStyle=QuoteStyle.Csv]),
 Headers=Table.PromoteHeaders(Source,[PromoteAllScalars=true]),
 Nulls=Table.ReplaceValue(Headers,"",null,Replacer.ReplaceValue,Table.ColumnNames(Headers)),
 Typed=Table.TransformColumnTypes(Nulls,{{"Mode",type text},{"Retrieved",type text}},"en-US")
in Typed