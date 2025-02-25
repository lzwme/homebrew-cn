cask "ricochet-refresh" do
  arch arm: "aarch64", intel: "x86_64"

  version "3.0.31"
  sha256 arm:   "9fc70273e35b61692dc16918d921142d1c0b07eda3bd09ca706d2f1c85d2651a",
         intel: "9084671d556fc975675ae85a97e2b58691bd99cf04f19f0d6503f7027c666dae"

  url "https:github.comblueprint-freespeechricochet-refreshreleasesdownloadv#{version}-releasericochet-refresh-#{version}-macos-#{arch}.dmg",
      verified: "github.comblueprint-freespeechricochet-refresh"
  name "Ricochet Refresh"
  desc "Private and anonymous instant messaging over tor"
  homepage "https:www.ricochetrefresh.net"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+[a-z]?)(?:[._-]release)?$i)
    strategy :github_latest
  end

  app "Ricochet Refresh.app"

  zap trash: "~LibraryApplication SupportRicochet-Refresh"
end