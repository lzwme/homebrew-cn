cask "font-lxgw-bright-tc" do
  version "5.526"
  sha256 "3028306493e0fd310fa6883b1977ac081ebf69b6ac54bb9e6e88de9308fa6109"

  url "https:github.comlxgwLxgwBrightreleasesdownloadv#{version}LXGWBrightTC.7z"
  name "LXGW Bright TC"
  homepage "https:github.comlxgwLxgwBright"

  no_autobump! because: :requires_manual_review

  font "LXGWBrightTCLXGWBrightTC-Italic.ttf"
  font "LXGWBrightTCLXGWBrightTC-Light.ttf"
  font "LXGWBrightTCLXGWBrightTC-LightItalic.ttf"
  font "LXGWBrightTCLXGWBrightTC-Medium.ttf"
  font "LXGWBrightTCLXGWBrightTC-MediumItalic.ttf"
  font "LXGWBrightTCLXGWBrightTC-Regular.ttf"

  # No zap stanza required
end