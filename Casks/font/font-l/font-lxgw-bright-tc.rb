cask "font-lxgw-bright-tc" do
  version "5.517"
  sha256 "43ed03a42f2ca8004fa6c4647e1f85a9f08380f58365b185852f14d3d2f81651"

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