cask "font-iosevka-ss01" do
  version "31.3.0"
  sha256 "2f52f1835aa8058521b17279de8d47428842e610bab9a7618607926c9831e286"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS01-#{version}.zip"
  name "Iosevka SS01"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS01.ttc"

  # No zap stanza required
end