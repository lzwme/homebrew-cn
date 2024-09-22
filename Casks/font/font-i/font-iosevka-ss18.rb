cask "font-iosevka-ss18" do
  version "31.7.0"
  sha256 "ab1d4ac9ed5e52ef7293edf1acf8b9ba71a47e0482806595cc72b436af8d1ce5"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS18-#{version}.zip"
  name "Iosevka SS18"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS18.ttc"

  # No zap stanza required
end