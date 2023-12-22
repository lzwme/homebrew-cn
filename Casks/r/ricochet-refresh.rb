cask "ricochet-refresh" do
  arch arm: "aarch64", intel: "x86_64"

  version "3.0.18"
  sha256 arm:   "4c5ac7f57c4fb84e847d83c8e65526bc04cbdc871137d0e6ff80330d3870ecec",
         intel: "bd9a05fb38dd9b526c94b34543b2d0f363965456522d07540613a75b9dfec890"

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