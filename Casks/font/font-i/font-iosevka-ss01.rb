cask "font-iosevka-ss01" do
  version "31.5.0"
  sha256 "5c6848aeeb92c6967636630da92db2f4a2da922641859760c4ba65d6c5204d76"

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