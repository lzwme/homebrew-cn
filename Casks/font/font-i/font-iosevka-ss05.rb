cask "font-iosevka-ss05" do
  version "33.2.4"
  sha256 "99be2059565dbbc95bbe44281fed182f41458a67f1e9800d814df77b78b4bc60"

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