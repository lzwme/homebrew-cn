cask "font-iosevka-ss07" do
  version "32.3.1"
  sha256 "601d8283068f1f32aa7a8b337c58e4058ea7113f677657bc9aa43bea1fdf3aa8"

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