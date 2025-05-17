cask "font-amiri" do
  version "1.002"
  sha256 "e39bea40fb64d77cb511a686d2506005b2e39a85166a4ebcf858111d416c14a5"

  url "https:github.comalif-typeamirireleasesdownload#{version}Amiri-#{version}.zip",
      verified: "github.comalif-typeamiri"
  name "Amiri"
  homepage "https:www.amirifont.org"

  font "Amiri-#{version}Amiri-Bold.ttf"
  font "Amiri-#{version}Amiri-BoldItalic.ttf"
  font "Amiri-#{version}Amiri-Italic.ttf"
  font "Amiri-#{version}Amiri-Regular.ttf"
  font "Amiri-#{version}AmiriQuran.ttf"
  font "Amiri-#{version}AmiriQuranColored.ttf"

  # No zap stanza required
end