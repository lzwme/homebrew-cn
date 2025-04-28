cask "folo" do
  arch arm: "arm64", intel: "x64"

  version "0.4.4"
  sha256 arm:   "394faec23bbde260468e80d8b184bb3616d582795813e2f4129c570c6585d6b2",
         intel: "a4086d1fdeb72ed6d70d591cb36fe3b8e7352411d75c220f0bc9703503ff301a"

  url "https:github.comRSSNextFoloreleasesdownloadv#{version}Folo-#{version}-macos-#{arch}.dmg",
      verified: "github.comRSSNextFolo"
  name "Folo"
  desc "Information browser"
  homepage "https:follow.is"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+(?:[._-]beta[._-]?\d+)?)$i)
    strategy :github_latest
  end

  auto_updates true
  conflicts_with cask: [
    "follow@alpha",
    "folo@nightly",
  ]
  depends_on macos: ">= :big_sur"

  app "Folo.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsis.follow.sfl*",
    "~LibraryApplication SupportFolo",
    "~LibraryLogsFolo",
    "~LibraryPreferencesis.follow.plist",
    "~LibrarySaved Application Stateis.follow.savedState",
  ]
end