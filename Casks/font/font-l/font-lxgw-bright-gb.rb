cask "font-lxgw-bright-gb" do
  version "5.517"
  sha256 "2ddfd3d6b8e85930cb6a5b142e5f94fe826413c8078e30e651ffeacda157dcc5"

  url "https:github.comlxgwLxgwBrightreleasesdownloadv#{version}LXGWBrightGB.7z"
  name "LXGW Bright GB"
  homepage "https:github.comlxgwLxgwBright"

  no_autobump! because: :requires_manual_review

  font "LXGWBrightGBLXGWBrightGB-Italic.ttf"
  font "LXGWBrightGBLXGWBrightGB-Light.ttf"
  font "LXGWBrightGBLXGWBrightGB-LightItalic.ttf"
  font "LXGWBrightGBLXGWBrightGB-Medium.ttf"
  font "LXGWBrightGBLXGWBrightGB-MediumItalic.ttf"
  font "LXGWBrightGBLXGWBrightGB-Regular.ttf"

  # No zap stanza required
end