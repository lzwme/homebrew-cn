cask "font-lxgw-bright-gb" do
  version "5.321"
  sha256 "bf7d298c1dc17fe05ea99bf1459b753a32641aec7faabeb92b4f68b171ea21a9"

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