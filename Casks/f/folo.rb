cask "folo" do
  arch arm: "arm64", intel: "x64"

  version "0.5.0"
  sha256 arm:   "637c4918b8c21916feea3e448a6cf3907dbd0f89d6af9c6c93d72105c2ca3d34",
         intel: "5a7c3e77bfb1a4ed6c9c72d101ce944f21cf55dcf080347f0cb5fcffa12bc2b7"

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