cask "reader" do
  version "0.1.1294"
  sha256 "67ed336796308f64992754c43d068835b22252a9c4e5f43be2819669d3719894"

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