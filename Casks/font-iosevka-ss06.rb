cask "font-iosevka-ss06" do
  version "28.0.2"
  sha256 "4c4743f18ebafb0a92c7d76604424101446e2a6050613bdfcd6c6b3a1ada819d"

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