# -----------------------------------------------------------------------------
# Proje: tcknvkn-crystal
# Dosya: tests/test_tcknvkn_spec.cr
# Açıklama: TCKN ve VKN doğrulama fonksiyonları için birim test senaryolarını içerir.
# Oluşturma Tarihi: 2026-04-24
# Lisans: MIT
# Site: https://www.tcknvkn.com
# -----------------------------------------------------------------------------
require "spec"
require "../src/tcknvkn"

describe Tcknvkn do
  it "tekil TCKN varyasyonlarını doğrular" do
    valid = Tcknvkn.validate_tckn("10000000146")
    valid[:valid].should be_true
    valid[:value].should eq("10000000146")
    valid[:errors].should be_empty

    normalized = Tcknvkn.validate_tckn("100-000 00146")
    normalized[:valid].should be_true
    normalized[:value].should eq("10000000146")

    wrong_length = Tcknvkn.validate_tckn("12345")
    wrong_length[:valid].should be_false
    wrong_length[:errors].should contain("11 haneli olmalıdır.")

    leading_zero = Tcknvkn.validate_tckn("01234567890")
    leading_zero[:valid].should be_false
    leading_zero[:errors].should contain("İlk hane 0 olamaz.")

    wrong_10 = Tcknvkn.validate_tckn("10000000156")
    wrong_10[:valid].should be_false
    wrong_10[:errors].should contain("10. hane kontrol hanesi hatalı.")

    wrong_11 = Tcknvkn.validate_tckn("10000000145")
    wrong_11[:valid].should be_false
    wrong_11[:errors].should contain("11. hane kontrol hanesi hatalı.")

    repeated = Tcknvkn.validate_tckn("11111111111")
    repeated[:valid].should be_false
    repeated[:errors].should contain("Geçersiz örüntü: tüm haneler aynı.")
  end

  it "tekil VKN varyasyonlarını doğrular" do
    valid = Tcknvkn.validate_vkn("1000036109")
    valid[:valid].should be_true
    valid[:value].should eq("1000036109")
    valid[:errors].should be_empty

    normalized = Tcknvkn.validate_vkn("100-003-6109")
    normalized[:valid].should be_true
    normalized[:value].should eq("1000036109")

    wrong_length = Tcknvkn.validate_vkn("1234")
    wrong_length[:valid].should be_false
    wrong_length[:errors].should contain("10 haneli olmalıdır.")

    wrong_checksum = Tcknvkn.validate_vkn("1000036108")
    wrong_checksum[:valid].should be_false
    wrong_checksum[:errors].should contain("Son hane kontrol hanesi hatalı.")

    repeated = Tcknvkn.validate_vkn("1111111111")
    repeated[:valid].should be_false
    repeated[:errors].should contain("Geçersiz örüntü: tüm haneler aynı.")
  end

  it "toplu TCKN doğrulamasında sıra korunur" do
    results = Tcknvkn.validate_multiple_tckn(["10000000146", "10000000145", "11111111111", "100-000 00146"])
    results.size.should eq(4)
    results[0][:valid].should be_true
    results[1][:valid].should be_false
    results[2][:valid].should be_false
    results[3][:valid].should be_true
  end

  it "toplu VKN doğrulamasında sıra korunur" do
    results = Tcknvkn.validate_multiple_vkn(["1000036109", "1000036108", "1111111111", "100-003-6109"])
    results.size.should eq(4)
    results[0][:valid].should be_true
    results[1][:valid].should be_false
    results[2][:valid].should be_false
    results[3][:valid].should be_true
  end
end