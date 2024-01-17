cask "reader" do
  version "0.1.60"
  sha256 "6de35ff64a7827d60eeb6ab3b29cb6e780fc3fb8da20fb4681e930897890cc42"

  url "https:github.comreadwiseioreader-desktop-releasesreleasesdownloadreader-desktop-v#{version}Reader_#{version}_universal.dmg",
      verified: "github.comreadwiseioreader-desktop-releases"
  name "Readwise Reader"
  desc "Save articles to read, highlight key content, and organize notes for review"
  homepage "https:readwise.ioread"

  livecheck do
    url "https:reader-desktop-releases.readwise.ioupdate-manifest.json"
    strategy :json do |json|
      json["version"]
    end
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