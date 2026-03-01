cask "font-iosevka-aile" do
  version "34.2.0"
  sha256 "da85a84b05c372b41648018a5d0c98e19a584ad5fdc01b3080a2451a118bba1e"

  url "https://ghfast.top/https://github.com/be5invis/Iosevka/releases/download/v#{version}/SuperTTC-IosevkaAile-#{version}.zip"
  name "Iosevka Aile"
  homepage "https://github.com/be5invis/Iosevka/"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaAile.ttc"

  # No zap stanza required
end