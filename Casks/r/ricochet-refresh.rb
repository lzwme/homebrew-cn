cask "ricochet-refresh" do
  arch arm: "aarch64", intel: "x86_64"

  version "3.0.25"
  sha256 arm:   "825b4b79b51b9d2c519176ea84e634e2043b6fe5de0ced523f7b425d0100e6bc",
         intel: "29a9eebc746514bd04bfb2b2c6210ccdf61ff48dea0bab91fd995f3615327afb"

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