let
 Source=Csv.Document(Binary.FromText("Q2FwYWNpdHlrV3AKMjUKNTAKMTAwCjI1MAo1MDAK",BinaryEncoding.Base64),[Delimiter=",",Encoding=65001,QuoteStyle=QuoteStyle.Csv]),
 Headers=Table.PromoteHeaders(Source,[PromoteAllScalars=true]),
 Nulls=Table.ReplaceValue(Headers,"",null,Replacer.ReplaceValue,Table.ColumnNames(Headers)),
 Typed=Table.TransformColumnTypes(Nulls,{{"CapacitykWp",Int64.Type}},"en-US")
in Typed