cask "reader" do
  version "0.1.1672"
  sha256 "621144bd418c7c61dca080baad493ff1d444a05ba1bdcb17b7f45e2c2ef3ef14"

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