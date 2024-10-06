cask "font-iosevka-etoile" do
  version "31.8.0"
  sha256 "ca5b55798ee94a518b86f2aaaf907ad7f658bf4347df7fb03538033fdba62205"

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