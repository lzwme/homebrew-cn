cask "font-iosevka-ss13" do
  version "33.2.6"
  sha256 "697a255104880045da1dc64995ab4f5414b90bbee30ed3ac81525a06064b7c59"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS13-#{version}.zip"
  name "Iosevka SS13"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS13.ttc"

  # No zap stanza required
end