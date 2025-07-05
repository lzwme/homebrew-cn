cask "font-migmix-1p" do
  version "2020.0307"
  sha256 "586660e48dc24f95c6fed49852eedb0185485ffc731cc4128acd10fd98813b8c"

  url "https://ghfast.top/https://github.com/itouhiro/mixfont-mplus-ipa/releases/download/v#{version}/migmix-1p-#{version.no_dots}.zip",
      verified: "github.com/itouhiro/mixfont-mplus-ipa/"
  name "MigMix 1P"
  homepage "https://itouhiro.github.io/mixfont-mplus-ipa/migmix/"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/v?(\d+(?:\.\d+)+)/migmix-1p[._-]}i)
  end

  no_autobump! because: :requires_manual_review

  font "migmix-1p-#{version.no_dots}/migmix-1p-bold.ttf"
  font "migmix-1p-#{version.no_dots}/migmix-1p-regular.ttf"

  # No zap stanza required
end