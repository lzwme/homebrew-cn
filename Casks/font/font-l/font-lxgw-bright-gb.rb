cask "font-lxgw-bright-gb" do
  version "5.526"
  sha256 "e2adc37688c94fc152d1fc40186c37f3380bf6188d269aad61b88331e7ecd35c"

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