cask "font-iosevka-ss10" do
  version "28.0.3"
  sha256 "abf7c572f568fd3f844cd367edee540aadfe4b57911ce921ee6ad503144ea754"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}PkgTTC-IosevkaSS10-#{version}.zip"
  name "Iosevka SS10"
  desc "Sans-serif, slab-serif, monospace and quasi‑proportional typeface family"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS10-Bold.ttc"
  font "IosevkaSS10-ExtraBold.ttc"
  font "IosevkaSS10-ExtraLight.ttc"
  font "IosevkaSS10-Heavy.ttc"
  font "IosevkaSS10-Light.ttc"
  font "IosevkaSS10-Medium.ttc"
  font "IosevkaSS10-Regular.ttc"
  font "IosevkaSS10-SemiBold.ttc"
  font "IosevkaSS10-Thin.ttc"

  # No zap stanza required
end