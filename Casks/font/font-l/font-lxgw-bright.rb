cask "font-lxgw-bright" do
  version "5.500"
  sha256 "e93fc20125bbd4741122e613090d2940cff213ebf96e63a650fbfa0e527b278c"

  url "https:github.comlxgwLxgwBrightreleasesdownloadv#{version}LXGWBright.7z"
  name "LXGW Bright"
  homepage "https:github.comlxgwLxgwBright"

  font "LXGWBrightLXGWBright-Italic.ttf"
  font "LXGWBrightLXGWBright-Light.ttf"
  font "LXGWBrightLXGWBright-LightItalic.ttf"
  font "LXGWBrightLXGWBright-Medium.ttf"
  font "LXGWBrightLXGWBright-MediumItalic.ttf"
  font "LXGWBrightLXGWBright-Regular.ttf"

  # No zap stanza required
end