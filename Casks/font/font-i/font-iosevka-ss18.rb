cask "font-iosevka-ss18" do
  version "32.5.0"
  sha256 "3c497ede3a4b5f851971a7cd9adea5f288a9d2ef07cd09050104ec63cd1650b0"

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