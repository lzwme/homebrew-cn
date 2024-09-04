cask "font-chiron-hei-hk" do
  version "2.516"
  sha256 "ccc42fdceed25cc5a96ed8db663d8a1d0e0b0fe16a1dad074b6eae8cff56446d"

  url "https:github.comchiron-fontschiron-hei-hkarchiverefstagsv#{version}.tar.gz"
  name "Chiron Hei HK"
  name "昭源黑體"
  homepage "https:github.comchiron-fontschiron-hei-hk"

  font "chiron-hei-hk-#{version}VARChironHeiHKItVF.otf"
  font "chiron-hei-hk-#{version}VARChironHeiHKVF.otf"

  # No zap stanza required
end