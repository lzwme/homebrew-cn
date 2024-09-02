cask "font-iosevka-ss08" do
  version "31.5.0"
  sha256 "d77537a99046f44e0d6475156404ee9919fa4a0d36006f2c1e4fe857eda65391"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS08-#{version}.zip"
  name "Iosevka SS08"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS08.ttc"

  # No zap stanza required
end