cask "font-iosevka-ss18" do
  version "33.1.0"
  sha256 "f390efbec14f14a88630675864c034682b77571bfdee9c4c7998354502f09836"

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