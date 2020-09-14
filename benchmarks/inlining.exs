string_medium = "gOYTe31WGialOUHBzdvHTVJKLe82qaN9HXH1Iey2F5UoArCqATFyx0DqKzVfpv50KqE57UNPoMPDFw7040x3fzMXCURcvw82RokCh0IpNFXNcf3hBHWqZmQnfdKL7PG6"
string_medium_len = byte_size(string_medium)

Benchee.run(%{
  "string_medium" => fn -> RowBinary.encode(string_medium, [:string]) end,
})
