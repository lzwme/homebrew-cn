cask "font-iosevka-ss11" do
  version "32.2.1"
  sha256 "66c8280694301bdf89663625c74df90f720fa69a9d969ce00fc131fd790c0edc"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS11-#{version}.zip"
  name "Iosevka SS11"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS11.ttc"

  # No zap stanza required
end