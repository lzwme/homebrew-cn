cask "obsidian" do
  version "1.4.16"
  sha256 "c9d2d6afe4a79336bd1be47b1db3ee51da19b0bdb9523f8a0e8b3aeccabfbab6"

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