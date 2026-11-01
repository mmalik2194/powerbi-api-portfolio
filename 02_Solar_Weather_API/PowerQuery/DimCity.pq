let
 Source=Csv.Document(Binary.FromText("Q2l0eSxMYXRpdHVkZSxMb25naXR1ZGUKU3lkbmV5LC0zMy44Njg4LDE1MS4yMDkzCk1lbGJvdXJuZSwtMzcuODEzNiwxNDQuOTYzMQpCcmlzYmFuZSwtMjcuNDY5OCwxNTMuMDI1MQpQZXJ0aCwtMzEuOTUyMywxMTUuODYxMwpBZGVsYWlkZSwtMzQuOTI4NSwxMzguNjAwNwo=",BinaryEncoding.Base64),[Delimiter=",",Encoding=65001,QuoteStyle=QuoteStyle.Csv]),
 Headers=Table.PromoteHeaders(Source,[PromoteAllScalars=true]),
 Nulls=Table.ReplaceValue(Headers,"",null,Replacer.ReplaceValue,Table.ColumnNames(Headers)),
 Typed=Table.TransformColumnTypes(Nulls,{{"City",type text},{"Latitude",type number},{"Longitude",type number}},"en-US")
in Typed