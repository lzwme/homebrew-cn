cask "obsidian" do
  version "1.5.8"
  sha256 "e6894d98e2c4f40815532458f0fca550f19820c4be2a80c6de0d81302c927721"

  url "https:github.comobsidianmdobsidian-releasesreleasesdownloadv#{version}Obsidian-#{version}-universal.dmg",
      verified: "github.comobsidianmd"
  name "Obsidian"
  desc "Knowledge base that works on top of a local folder of plain text Markdown files"
  homepage "https:obsidian.md"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Obsidian.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsmd.obsidian.sfl*",
    "~LibraryApplication Supportobsidian",
    "~LibraryPreferencesmd.obsidian.plist",
    "~LibrarySaved Application Statemd.obsidian.savedState",
  ]
end