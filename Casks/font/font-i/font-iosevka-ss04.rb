cask "font-iosevka-ss04" do
  version "30.1.2"
  sha256 "0a67467cb395d1c710ebb2eed91cdc73db6fbfc3e513fa5cba0786683eb16aae"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}PkgTTC-IosevkaSS04-#{version}.zip"
  name "Iosevka SS04"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS04-Bold.ttc"
  font "IosevkaSS04-ExtraBold.ttc"
  font "IosevkaSS04-ExtraLight.ttc"
  font "IosevkaSS04-Heavy.ttc"
  font "IosevkaSS04-Light.ttc"
  font "IosevkaSS04-Medium.ttc"
  font "IosevkaSS04-Regular.ttc"
  font "IosevkaSS04-SemiBold.ttc"
  font "IosevkaSS04-Thin.ttc"

  # No zap stanza required
end