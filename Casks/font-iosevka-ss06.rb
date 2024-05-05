cask "font-iosevka-ss06" do
  version "30.0.0"
  sha256 "3a6cfc7f3305bba296fced6d52e501e2e2a3d2efcbf8d0873bff402d085ac071"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}PkgTTC-IosevkaSS06-#{version}.zip"
  name "Iosevka SS06"
  desc "Sans-serif, slab-serif, monospace and quasi‑proportional typeface family"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS06-Bold.ttc"
  font "IosevkaSS06-ExtraBold.ttc"
  font "IosevkaSS06-ExtraLight.ttc"
  font "IosevkaSS06-Heavy.ttc"
  font "IosevkaSS06-Light.ttc"
  font "IosevkaSS06-Medium.ttc"
  font "IosevkaSS06-Regular.ttc"
  font "IosevkaSS06-SemiBold.ttc"
  font "IosevkaSS06-Thin.ttc"

  # No zap stanza required
end