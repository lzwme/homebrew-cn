cask "font-lxgw-bright" do
  version "5.510"
  sha256 "8dff95825b9e694ad65d65ecc921d80eb1ac84d931ddac7d67760604f6e89332"

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