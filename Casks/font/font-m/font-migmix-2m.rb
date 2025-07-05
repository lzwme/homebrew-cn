cask "font-migmix-2m" do
  version "2023.1123"
  sha256 "187486f875a980eb5c68751e2df86d7ed3c376c8ffd6fe3c5d2e5d79257b207b"

  url "https://ghfast.top/https://github.com/itouhiro/mixfont-mplus-ipa/releases/download/v#{version}/migmix-2m-#{version.no_dots}.zip",
      verified: "github.com/itouhiro/mixfont-mplus-ipa/"
  name "MigMix 2M"
  homepage "https://itouhiro.github.io/mixfont-mplus-ipa/migmix/"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/v?(\d+(?:\.\d+)+)/migmix-2m[._-]}i)
  end

  no_autobump! because: :requires_manual_review

  font "migmix-2m-#{version.no_dots}/migmix-2m-bold.ttf"
  font "migmix-2m-#{version.no_dots}/migmix-2m-regular.ttf"

  # No zap stanza required
end