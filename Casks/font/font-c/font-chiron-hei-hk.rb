cask "font-chiron-hei-hk" do
  version "2.514"
  sha256 "bec3536907115e6b1e97fba94e6d44aa1106a62329e048a5f47f5ac3e9d4811e"

  url "https:github.comchiron-fontschiron-hei-hkarchiverefstagsv#{version}.tar.gz"
  name "Chiron Hei HK"
  name "昭源黑體"
  homepage "https:github.comchiron-fontschiron-hei-hk"

  font "chiron-hei-hk-#{version}VARChironHeiHKItVF.otf"
  font "chiron-hei-hk-#{version}VARChironHeiHKVF.otf"

  # No zap stanza required
end