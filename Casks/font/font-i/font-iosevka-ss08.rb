cask "font-iosevka-ss08" do
  version "30.3.1"
  sha256 "fafbcb1f9eb0765fdd3a0f21f761c7864b257edb8d1cff21769198d5df5094a4"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}PkgTTC-IosevkaSS08-#{version}.zip"
  name "Iosevka SS08"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS08-Bold.ttc"
  font "IosevkaSS08-ExtraBold.ttc"
  font "IosevkaSS08-ExtraLight.ttc"
  font "IosevkaSS08-Heavy.ttc"
  font "IosevkaSS08-Light.ttc"
  font "IosevkaSS08-Medium.ttc"
  font "IosevkaSS08-Regular.ttc"
  font "IosevkaSS08-SemiBold.ttc"
  font "IosevkaSS08-Thin.ttc"

  # No zap stanza required
end