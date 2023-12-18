cask "font-lxgw-bright" do
  version "5.311"
  sha256 "4ae422555715066807a3c6feabd5aa193388fc4a02fbc2184eaae510049653a6"

  url "https:github.comlxgwLxgwBrightreleasesdownloadv#{version}LXGWBright.7z"
  name "LXGW Bright"
  desc "Merged font of Ysabeau Office and LXGW WenKai Lite"
  homepage "https:github.comlxgwLxgwBright"

  font "LXGWBrightLXGWBright-Italic.otf"
  font "LXGWBrightLXGWBright-Medium.otf"
  font "LXGWBrightLXGWBright-MediumItalic.otf"
  font "LXGWBrightLXGWBright-Regular.otf"
  font "LXGWBrightLXGWBright-SemiLight.otf"
  font "LXGWBrightLXGWBright-SemiLightItalic.otf"

  # No zap stanza required
end