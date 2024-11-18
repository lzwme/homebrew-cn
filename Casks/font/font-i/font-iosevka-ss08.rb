cask "font-iosevka-ss08" do
  version "32.1.0"
  sha256 "d4fe1357a5d95c413e08f3e428d24b57a3f5e67052a2520fc925cab0e53c896a"

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