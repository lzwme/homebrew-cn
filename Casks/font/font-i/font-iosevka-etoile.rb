cask "font-iosevka-etoile" do
  version "33.0.0"
  sha256 "f7239a36363e0a488f0c3366871ff7cda9a0895aaa4a128431fbd466de2fbdc3"

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