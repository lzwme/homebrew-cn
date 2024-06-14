cask "font-lxgw-bright-gb" do
  version "5.330"
  sha256 "f9378f55d7c77216be7b430ec5b9a834d89e92a16fd640eb5a32d73b43adc3a0"

  url "https:github.comlxgwLxgwBrightreleasesdownloadv#{version}LXGWBrightGB.7z"
  name "LXGW Bright GB"
  homepage "https:github.comlxgwLxgwBright"

  font "LXGWBrightGBLXGWBrightGB-Medium.ttf"
  font "LXGWBrightGBLXGWBrightGB-MediumItalic.ttf"
  font "LXGWBrightGBLXGWBrightGB-Regular.ttf"
  font "LXGWBrightGBLXGWBrightGB-Italic.ttf"
  font "LXGWBrightGBLXGWBrightGB-SemiLight.ttf"
  font "LXGWBrightGBLXGWBrightGB-SemiLightItalic.ttf"

  # No zap stanza required
end