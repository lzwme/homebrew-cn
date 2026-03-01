cask "font-iosevka-etoile" do
  version "34.2.0"
  sha256 "b722566dc8c355344f8c0192b1266d8d418f3d7af0bb4b5dc99e036eaee9b5a2"

  url "https://ghfast.top/https://github.com/be5invis/Iosevka/releases/download/v#{version}/SuperTTC-IosevkaEtoile-#{version}.zip"
  name "Iosevka Etoile"
  homepage "https://github.com/be5invis/Iosevka/"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaEtoile.ttc"

  # No zap stanza required
end