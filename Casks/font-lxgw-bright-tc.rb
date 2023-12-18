cask "font-lxgw-bright-tc" do
  version "5.311"
  sha256 "62459d13af1d3f77ab84c9c24a1f26c81417ffd3dc268a4d21617d15150841c5"

  url "https:github.comlxgwLxgwBrightreleasesdownloadv#{version}LXGWBrightTC.7z"
  name "LXGW Bright TC"
  desc "Merged font of Ysabeau Office and LXGW WenKai TC"
  homepage "https:github.comlxgwLxgwBright"

  font "LXGWBrightTCLXGWBrightTC-Medium.otf"
  font "LXGWBrightTCLXGWBrightTC-MediumItalic.otf"
  font "LXGWBrightTCLXGWBrightTC-Regular.otf"
  font "LXGWBrightTCLXGWBrightTC-Italic.otf"
  font "LXGWBrightTCLXGWBrightTC-SemiLight.otf"
  font "LXGWBrightTCLXGWBrightTC-SemiLightItalic.otf"

  # No zap stanza required
end