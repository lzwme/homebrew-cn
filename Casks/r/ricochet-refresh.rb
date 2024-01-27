cask "ricochet-refresh" do
  arch arm: "aarch64", intel: "x86_64"

  version "3.0.19"
  sha256 arm:   "d93eaa15401645b5ee5f8c7b099e21ec879ecfd13fd394353dec074136c98fdf",
         intel: "1885d755ba2d651c2f345c96cfdb597bf820f0f2349b0594d08eda4cda941ef2"

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