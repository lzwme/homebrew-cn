cask "font-chiron-hei-hk" do
  version "2.519"
  sha256 "4271c6f229ec21f2c4dd1c7976df6ed4724e9a4fb7f948fdec63e1d980cfd16f"

  url "https:github.comchiron-fontschiron-hei-hkarchiverefstagsv#{version}.tar.gz"
  name "Chiron Hei HK"
  name "昭源黑體"
  homepage "https:github.comchiron-fontschiron-hei-hk"

  font "chiron-hei-hk-#{version}VARChironHeiHKItVF.otf"
  font "chiron-hei-hk-#{version}VARChironHeiHKVF.otf"

  # No zap stanza required
end