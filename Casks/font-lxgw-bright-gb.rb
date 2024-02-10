cask "font-lxgw-bright-gb" do
  version "5.320"
  sha256 "f9df021cdd733e51fc37f9c5554ade463f31d5b4967b66560d40b5079f278f45"

  url "https:github.comlxgwLxgwBrightreleasesdownloadv#{version}LXGWBrightGB.7z"
  name "LXGW Bright GB"
  desc "Merged font of Ysabeau Office and LXGW WenKai GB"
  homepage "https:github.comlxgwLxgwBright"

  font "LXGWBrightGBLXGWBrightGB-Medium.otf"
  font "LXGWBrightGBLXGWBrightGB-MediumItalic.otf"
  font "LXGWBrightGBLXGWBrightGB-Regular.otf"
  font "LXGWBrightGBLXGWBrightGB-Italic.otf"
  font "LXGWBrightGBLXGWBrightGB-SemiLight.otf"
  font "LXGWBrightGBLXGWBrightGB-SemiLightItalic.otf"

  # No zap stanza required
end