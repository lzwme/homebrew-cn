cask "reader" do
  version "0.1.927"
  sha256 "8996e04b60eaff7a1d3cfe914d2d49350472c7f72a30b99597f953b59d507f0a"

  url "https:github.comreadwiseioreader-desktop-releasesreleasesdownloadreader-desktop-v#{version}Reader_#{version}_universal.dmg",
      verified: "github.comreadwiseioreader-desktop-releases"
  name "Readwise Reader"
  desc "Save articles to read, highlight key content, and organise notes for review"
  homepage "https:readwise.ioread"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Reader.app"

  zap trash: [
    "~LibraryApplication Supportio.readwise.read",
    "~LibraryCachesio.readwise.read",
    "~LibraryHTTPStoragesio.readwise.read.binarycookies",
    "~LibrarySaved Application Stateio.readwise.read.savedState",
    "~LibraryWebKitio.readwise.read",
  ]
end