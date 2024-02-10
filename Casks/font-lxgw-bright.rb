cask "font-lxgw-bright" do
  version "5.320"
  sha256 "d678cf8302db9837eba2156f7c7c4963d703e635dc7761c07208453251553f02"

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