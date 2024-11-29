cask "font-iosevka-slab" do
  version "32.2.0"
  sha256 "2d75250cf1cbdb90b14e778a5b6b7742784c50f20ec076354a38540903adcdaf"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSlab-#{version}.zip"
  name "Iosevka Slab"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSlab.ttc"

  # No zap stanza required
end