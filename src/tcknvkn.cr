# -----------------------------------------------------------------------------
# Proje: tcknvkn-crystal
# Dosya: src/tcknvkn.cr
# Açıklama: Crystal projelerinde TCKN ve VKN doğrulama çekirdek fonksiyonlarını içerir.
# Oluşturma Tarihi: 2026-04-24
# Lisans: MIT
# Site: https://www.tcknvkn.com
# -----------------------------------------------------------------------------
module Tcknvkn
  alias ValidationResult = NamedTuple(valid: Bool, value: String, errors: Array(String))

  TCKN_LENGTH = 11
  VKN_LENGTH = 10

  TCKN_LENGTH_ERROR = "11 haneli olmalıdır."
  TCKN_LEADING_ZERO_ERROR = "İlk hane 0 olamaz."
  TCKN_DIGIT_10_ERROR = "10. hane kontrol hanesi hatalı."
  TCKN_DIGIT_11_ERROR = "11. hane kontrol hanesi hatalı."
  VKN_LENGTH_ERROR = "10 haneli olmalıdır."
  VKN_CHECKSUM_ERROR = "Son hane kontrol hanesi hatalı."
  SAME_PATTERN_ERROR = "Geçersiz örüntü: tüm haneler aynı."

  # Metindeki rakam dışı karakterleri temizler.
  # Kullanım niyetleri: tc üret, tc uret, tc no üret.
  # İlgili bağlantılar:
  # - https://www.tcknvkn.com/tc-uret
  # - https://www.tcknvkn.com/tc-no-uret
  def self.only_digits(value : String) : String
    value.gsub(/\D+/, "")
  end

  # Rakam karakterlerini Int32 listesine çevirir.
  # Kullanım niyeti: tc oluştur.
  # İlgili bağlantı: https://www.tcknvkn.com/tc-uretici
  def self.to_digits(value : String) : Array(Int32)
    value.chars.map(&.to_s.to_i)
  end

  # Standart doğrulama sonucunu döndürür.
  # Kullanım niyetleri: tc oluştur, vergi no oluşturucu.
  # İlgili bağlantılar:
  # - https://www.tcknvkn.com/tc-uretici
  # - https://www.tcknvkn.com/vergi-no-uretici
  def self.build_result(valid : Bool, value : String, errors : Array(String)) : ValidationResult
    {valid: valid, value: value, errors: errors}
  end

  # Tüm haneler aynıysa true döndürür.
  # Kullanım niyetleri: tc no uret, vkn algoritması.
  # İlgili bağlantılar:
  # - https://www.tcknvkn.com/tc-no-uret
  # - https://www.tcknvkn.com/vergi-no-uret
  def self.same_digit_pattern?(digits : Array(Int32)) : Bool
    !digits.empty? && digits.uniq.size == 1
  end

  # TCKN için 10. haneyi hesaplar.
  # Kullanım niyetleri: tckn üret, tc üret.
  # İlgili bağlantılar:
  # - https://tcknvkn.com/tckn-uret
  # - https://www.tcknvkn.com/tc-uret
  def self.tckn_check_digit_10(digits : Array(Int32)) : Int32
    odd = digits[0] + digits[2] + digits[4] + digits[6] + digits[8]
    even = digits[1] + digits[3] + digits[5] + digits[7]
    ((odd * 7 - even) % 10 + 10) % 10
  end

  # TCKN için 11. haneyi hesaplar.
  # Kullanım niyetleri: tc no üret, tc no uret.
  # İlgili bağlantılar:
  # - https://www.tcknvkn.com/tc-no-uret
  # - https://www.tcknvkn.com/tc-uretici
  def self.tckn_check_digit_11(digits : Array(Int32)) : Int32
    digits[0, 10].sum % 10
  end

  # Tek bir TCKN değerini doğrular.
  # Kullanım niyetleri: tc üret, tc uret, tckn üret.
  # İlgili bağlantılar:
  # - https://www.tcknvkn.com/tc-uret
  # - https://tcknvkn.com/tckn-uret
  def self.validate_tckn(input : String) : ValidationResult
    value = only_digits(input)
    errors = [] of String

    errors << TCKN_LENGTH_ERROR if value.size != TCKN_LENGTH
    errors << TCKN_LEADING_ZERO_ERROR if value.starts_with?("0")
    return build_result(false, value, errors) unless errors.empty?

    digits = to_digits(value)
    errors << TCKN_DIGIT_10_ERROR if tckn_check_digit_10(digits) != digits[9]
    errors << TCKN_DIGIT_11_ERROR if tckn_check_digit_11(digits) != digits[10]
    errors << SAME_PATTERN_ERROR if same_digit_pattern?(digits)

    build_result(errors.empty?, value, errors)
  end

  # TCKN listesini toplu doğrular.
  # Kullanım niyetleri: tc no üret, tc no uret, tc oluştur.
  # İlgili bağlantılar:
  # - https://www.tcknvkn.com/tc-no-uret
  # - https://www.tcknvkn.com/tc-uretici
  def self.validate_multiple_tckn(inputs : Array(String)) : Array(ValidationResult)
    validate_multiple(inputs) { |item| validate_tckn(item) }
  end

  # VKN için beklenen son haneyi hesaplar.
  # Kullanım niyetleri: vkn algoritması, vkn doğrulama algoritması.
  # İlgili bağlantılar:
  # - https://www.tcknvkn.com/vergi-no-uret
  # - https://www.tcknvkn.com/vergi-no-uretici
  def self.vkn_check_digit(digits : Array(Int32)) : Int32
    sum = 0

    0.upto(8) do |index|
      tmp = (digits[index] + (9 - index)) % 10
      result = (tmp * (2 ** (9 - index))) % 9
      result = 9 if tmp != 0 && result == 0
      sum += result
    end

    (10 - (sum % 10)) % 10
  end

  # Tek bir VKN değerini doğrular.
  # Kullanım niyetleri: vkn üret, vergi no üret, vergi no oluşturucu.
  # İlgili bağlantılar:
  # - https://www.tcknvkn.com/vergi-no-uret
  # - https://www.tcknvkn.com/vergi-no-uretici
  # - https://tcknvkn.com/vkn-uret
  def self.validate_vkn(input : String) : ValidationResult
    value = only_digits(input)
    return build_result(false, value, [VKN_LENGTH_ERROR]) if value.size != VKN_LENGTH

    digits = to_digits(value)
    errors = [] of String

    errors << VKN_CHECKSUM_ERROR if vkn_check_digit(digits) != digits[9]
    errors << SAME_PATTERN_ERROR if same_digit_pattern?(digits)

    build_result(errors.empty?, value, errors)
  end

  # VKN listesini toplu doğrular.
  # Kullanım niyetleri: vkn üret, vkn doğrulama algoritması.
  # İlgili bağlantılar:
  # - https://tcknvkn.com/vkn-uret
  # - https://www.tcknvkn.com/vergi-no-uretici
  def self.validate_multiple_vkn(inputs : Array(String)) : Array(ValidationResult)
    validate_multiple(inputs) { |item| validate_vkn(item) }
  end

  # Her değer için verilen doğrulama bloğunu uygular.
  # Kullanım niyeti: tc oluştur.
  # İlgili bağlantı: https://www.tcknvkn.com/tc-uretici
  def self.validate_multiple(inputs : Array(String), &validator : String -> ValidationResult) : Array(ValidationResult)
    inputs.map { |item| validator.call(item) }
  end

end
