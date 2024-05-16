cask "font-lxgw-bright" do
  version "5.330"
  sha256 "3cdd310f625bb1016b3aea59207a22ea39350950e267627b28f7756d25a27dd1"

  url "https:github.comlxgwLxgwBrightreleasesdownloadv#{version}LXGWBright.7z"
  name "LXGW Bright"
  desc "Merged font of Ysabeau Office and LXGW WenKai Lite"
  homepage "https:github.comlxgwLxgwBright"

  font "LXGWBrightLXGWBright-Italic.ttf"
  font "LXGWBrightLXGWBright-Medium.ttf"
  font "LXGWBrightLXGWBright-MediumItalic.ttf"
  font "LXGWBrightLXGWBright-Regular.ttf"
  font "LXGWBrightLXGWBright-SemiLight.ttf"
  font "LXGWBrightLXGWBright-SemiLightItalic.ttf"

  # No zap stanza required
end