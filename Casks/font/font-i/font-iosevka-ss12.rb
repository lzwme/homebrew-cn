cask "font-iosevka-ss12" do
  version "32.0.1"
  sha256 "c52841a622df6246f6258a5f7442abf71b405439e56edc08dbe196d6769ceccd"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS12-#{version}.zip"
  name "Iosevka SS12"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS12.ttc"

  # No zap stanza required
end