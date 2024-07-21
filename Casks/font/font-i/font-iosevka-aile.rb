cask "font-iosevka-aile" do
  version "30.3.3"
  sha256 "46165514ddaaa9b0689cf66a2ae69befd6aabe2bbfeef037ee1af75370a835bb"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}PkgTTC-IosevkaAile-#{version}.zip"
  name "Iosevka Aile"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaAile-Bold.ttc"
  font "IosevkaAile-ExtraBold.ttc"
  font "IosevkaAile-ExtraLight.ttc"
  font "IosevkaAile-Heavy.ttc"
  font "IosevkaAile-Light.ttc"
  font "IosevkaAile-Medium.ttc"
  font "IosevkaAile-Regular.ttc"
  font "IosevkaAile-SemiBold.ttc"
  font "IosevkaAile-Thin.ttc"

  # No zap stanza required
end