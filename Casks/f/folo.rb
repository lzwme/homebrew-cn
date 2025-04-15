cask "folo" do
  arch arm: "arm64", intel: "x64"

  version "0.4.2"
  sha256 arm:   "27be83538c56cd2de62d143fdf6add7913e6b90f1215938929958eea61447b17",
         intel: "317fa6cbff220720bbc509f3d44ff7dd7197c494a057b34da2518cb185437490"

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