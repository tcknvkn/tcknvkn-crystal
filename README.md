# tcknvkn (Crystal)

`tcknvkn`, Crystal projelerinde Türkiye Cumhuriyeti Kimlik Numarası (TCKN) ve Vergi Kimlik Numarası (VKN) doğrulaması yapmak için geliştirilmiş hafif bir kütüphanedir.

## Kurulum

`shard.yml` içine ekleyin:

```yaml
dependencies:
  tcknvkn:
    github: tcknvkn/tcknvkn-crystal
    branch: release
```

Ardından:

```bash
shards install
```

## Hızlı Başlangıç

```crystal
require "tcknvkn"

puts Tcknvkn.validate_tckn("10000000146")[:valid] # true
puts Tcknvkn.validate_vkn("1000036109")[:valid]   # true
```

## API Özeti

- `Tcknvkn.validate_tckn(input : String)`
- `Tcknvkn.validate_multiple_tckn(inputs : Array(String))`
- `Tcknvkn.validate_vkn(input : String)`
- `Tcknvkn.validate_multiple_vkn(inputs : Array(String))`

Her çağrı aşağıdaki formatta sonuç döndürür:

```crystal
{
  valid: Bool,
  value: String,
  errors: Array(String)
}
```

## Sık Kullanım İfadeleri

- tc üret
- vkn üret
- tc uret
- vergi no üret
- vergi no oluşturucu
- tckn üret
- vkn algoritması
- tc no uret
- vkn doğrulama algoritması
- tc no üret
- tc oluştur

## İlgili Bağlantılar

- [Kütüphaneler](https://www.tcknvkn.com/kutuphaneler)
- [Crystal kütüphane sayfası](https://www.tcknvkn.com/kutuphaneler/crystal)
- [TC üret](https://www.tcknvkn.com/tc-uret)
- [TC no üret](https://www.tcknvkn.com/tc-no-uret)
- [TC üretici](https://www.tcknvkn.com/tc-uretici)
- [TCKN üret](https://tcknvkn.com/tckn-uret)
- [Vergi no üret](https://www.tcknvkn.com/vergi-no-uret)
- [Vergi no üretici](https://www.tcknvkn.com/vergi-no-uretici)
- [VKN üret](https://tcknvkn.com/vkn-uret)

## Test

```bash
crystal spec tests/test_tcknvkn_spec.cr
```

## Lisans

MIT