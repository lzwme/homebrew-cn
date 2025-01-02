cask "font-iosevka-slab" do
  version "32.3.1"
  sha256 "83948313457b644c8766912137324c53d09a8dde20de40959b89caa87609384d"

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