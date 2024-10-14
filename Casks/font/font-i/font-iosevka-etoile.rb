cask "font-iosevka-etoile" do
  version "31.9.0"
  sha256 "e7b9e47789065d29a52a803e323eda81046bb8c0dadc33b8038b818fa875ebda"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaEtoile-#{version}.zip"
  name "Iosevka Etoile"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaEtoile.ttc"

  # No zap stanza required
end