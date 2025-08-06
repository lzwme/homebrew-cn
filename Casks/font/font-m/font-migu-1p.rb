cask "font-migu-1p" do
  version "2020.0307"
  sha256 "2e632832e7984400654bf666775c0fba14e18191765b64b6477e65b14c3a624a"

  url "https://ghfast.top/https://github.com/itouhiro/mixfont-mplus-ipa/releases/download/v#{version}/migu-1p-#{version.no_dots}.zip",
      verified: "github.com/itouhiro/mixfont-mplus-ipa/"
  name "Migu 1P"
  homepage "https://itouhiro.github.io/mixfont-mplus-ipa/migu/"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/v?(\d+(?:\.\d+)+)/migu-1p[._-]}i)
  end

  font "migu-1p-#{version.no_dots}/migu-1p-bold.ttf"
  font "migu-1p-#{version.no_dots}/migu-1p-regular.ttf"

  # No zap stanza required
end