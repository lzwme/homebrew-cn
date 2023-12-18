cask "font-lxgw-bright-gb" do
  version "5.311"
  sha256 "1ea68416f4ff833fbbe05175d1ffce84fc69788d48ca0712994f8d5510571a75"

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