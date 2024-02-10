cask "font-lxgw-bright-tc" do
  version "5.320"
  sha256 "a69f789608d9921a2f385a7fe2c4ee57be8086d591622965517e42551d0142e7"

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