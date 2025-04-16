cask "folo@nightly" do
  arch arm: "arm64", intel: "x64"

  version "0.4.2"
  sha256 arm:   "27be83538c56cd2de62d143fdf6add7913e6b90f1215938929958eea61447b17",
         intel: "317fa6cbff220720bbc509f3d44ff7dd7197c494a057b34da2518cb185437490"

  url "https:github.comRSSNextFoloreleasesdownloadv#{version}Folo-#{version}-macos-#{arch}.dmg",
      verified: "github.comRSSNextFolo"
  name "Folo Nightly"
  desc "Information browser"
  homepage "https:follow.is"

  disable! date: "2025-04-15", because: :discontinued

  conflicts_with cask: [
    "follow@alpha",
    "folo",
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