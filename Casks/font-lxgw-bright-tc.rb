cask "font-lxgw-bright-tc" do
  version "5.330"
  sha256 "5a01c41e45b43fc3ca5eb49b147a1103199002895906b8d6436b65226b5257fe"

  url "https:github.comlxgwLxgwBrightreleasesdownloadv#{version}LXGWBrightTC.7z"
  name "LXGW Bright TC"
  desc "Merged font of Ysabeau Office and LXGW WenKai TC"
  homepage "https:github.comlxgwLxgwBright"

  font "LXGWBrightTCLXGWBrightTC-Medium.ttf"
  font "LXGWBrightTCLXGWBrightTC-MediumItalic.ttf"
  font "LXGWBrightTCLXGWBrightTC-Regular.ttf"
  font "LXGWBrightTCLXGWBrightTC-Italic.ttf"
  font "LXGWBrightTCLXGWBrightTC-SemiLight.ttf"
  font "LXGWBrightTCLXGWBrightTC-SemiLightItalic.ttf"

  # No zap stanza required
end