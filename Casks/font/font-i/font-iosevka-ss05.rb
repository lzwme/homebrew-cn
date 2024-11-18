cask "font-iosevka-ss05" do
  version "32.1.0"
  sha256 "8376ba654300b0064c9c5dd63310296f1086c3e17f28dca05c8a5248ca491d8d"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS05-#{version}.zip"
  name "Iosevka SS05"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS05.ttc"

  # No zap stanza required
end