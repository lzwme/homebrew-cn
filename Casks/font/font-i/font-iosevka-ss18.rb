cask "font-iosevka-ss18" do
  version "33.2.0"
  sha256 "f267c8f23d786e5d0d1b1b18e9448e30b57c06d71c3f9a8f2879f3f9bc90bd1f"

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