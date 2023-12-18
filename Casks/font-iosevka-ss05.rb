cask "font-iosevka-ss05" do
  version "28.0.1"
  sha256 "9b7ae89704dbd69d71043b69fc6a64db690bb7a2be67d24cb69a87435336532d"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}PkgTTC-IosevkaSS05-#{version}.zip"
  name "Iosevka SS05"
  desc "Sans-serif, slab-serif, monospace and quasi‑proportional typeface family"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS05-Bold.ttc"
  font "IosevkaSS05-ExtraBold.ttc"
  font "IosevkaSS05-ExtraLight.ttc"
  font "IosevkaSS05-Heavy.ttc"
  font "IosevkaSS05-Light.ttc"
  font "IosevkaSS05-Medium.ttc"
  font "IosevkaSS05-Regular.ttc"
  font "IosevkaSS05-SemiBold.ttc"
  font "IosevkaSS05-Thin.ttc"

  # No zap stanza required
end