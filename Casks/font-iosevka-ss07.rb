cask "font-iosevka-ss07" do
  version "29.0.2"
  sha256 "5018a754c5b874004495065b7f32ef8026bc1b8903cb905e0d40236b43d4f775"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}PkgTTC-IosevkaSS07-#{version}.zip"
  name "Iosevka SS07"
  desc "Sans-serif, slab-serif, monospace and quasi‑proportional typeface family"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS07-Bold.ttc"
  font "IosevkaSS07-ExtraBold.ttc"
  font "IosevkaSS07-ExtraLight.ttc"
  font "IosevkaSS07-Heavy.ttc"
  font "IosevkaSS07-Light.ttc"
  font "IosevkaSS07-Medium.ttc"
  font "IosevkaSS07-Regular.ttc"
  font "IosevkaSS07-SemiBold.ttc"
  font "IosevkaSS07-Thin.ttc"

  # No zap stanza required
end