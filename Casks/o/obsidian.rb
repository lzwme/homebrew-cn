cask "obsidian" do
  version "1.6.5"
  sha256 "800e859026a51b0d2982709b38996222d2f3306afe086f6bea648c76f5540284"

  url "https:github.comobsidianmdobsidian-releasesreleasesdownloadv#{version}Obsidian-#{version}.dmg",
      verified: "github.comobsidianmd"
  name "Obsidian"
  desc "Knowledge base that works on top of a local folder of plain text Markdown files"
  homepage "https:obsidian.md"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Obsidian.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsmd.obsidian.sfl*",
    "~LibraryApplication Supportobsidian",
    "~LibraryPreferencesmd.obsidian.plist",
    "~LibrarySaved Application Statemd.obsidian.savedState",
  ]
end