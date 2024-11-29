cask "font-iosevka-ss04" do
  version "32.2.0"
  sha256 "269c61c50621c377d63cd2c40e279169fb960157eccb5aa1cf92fdd02919c80f"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS04-#{version}.zip"
  name "Iosevka SS04"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS04.ttc"

  # No zap stanza required
end