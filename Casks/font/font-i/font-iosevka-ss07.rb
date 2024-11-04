cask "font-iosevka-ss07" do
  version "32.0.1"
  sha256 "e73f336fb49c86bca34f919f19ef201107de174ca65e4b21afdeed4cd7bc5245"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS07-#{version}.zip"
  name "Iosevka SS07"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS07.ttc"

  # No zap stanza required
end