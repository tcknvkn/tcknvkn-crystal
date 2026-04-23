# -----------------------------------------------------------------------------
# Proje: tcknvkn-crystal
# Dosya: examples/basic_usage.cr
# Açıklama: Crystal kütüphanesi için temel kullanım örneğini içerir.
# Oluşturma Tarihi: 2026-04-24
# Lisans: MIT
# Site: https://www.tcknvkn.com
# -----------------------------------------------------------------------------
require "../src/tcknvkn"

puts Tcknvkn.validate_tckn("10000000146")
puts Tcknvkn.validate_vkn("1000036109")