cask "font-lxgw-bright" do
  version "5.526"
  sha256 "e5502c2ad8142d496650d188a0645ec15ee6605c60ccdb21945f6bd6cd266e21"

  url "https:github.comlxgwLxgwBrightreleasesdownloadv#{version}LXGWBright.7z"
  name "LXGW Bright"
  homepage "https:github.comlxgwLxgwBright"

  no_autobump! because: :requires_manual_review

  font "LXGWBrightLXGWBright-Italic.ttf"
  font "LXGWBrightLXGWBright-Light.ttf"
  font "LXGWBrightLXGWBright-LightItalic.ttf"
  font "LXGWBrightLXGWBright-Medium.ttf"
  font "LXGWBrightLXGWBright-MediumItalic.ttf"
  font "LXGWBrightLXGWBright-Regular.ttf"

  # No zap stanza required
end