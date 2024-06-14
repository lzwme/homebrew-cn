cask "font-wix-madefor-text" do
  version "3.100"
  sha256 "7fdbd012ca9e245d7c177a341bdbdf789521590e175322a9013c035981138f1c"

  url "https:github.comwix-incubatorwixmadeforreleasesdownload#{version}wixmadefor-fonts.zip",
      verified: "github.comwix-incubatorwixmadefor"
  name "Wix Madefor Text"
  homepage "https:www.wix.comtypefacemadefor"

  font "wixmadefor-fontsfontsvariableWixMadeforText[wght].ttf"
  font "wixmadefor-fontsfontsvariableWixMadeforText-Italic[wght].ttf"

  # No zap stanza required
end