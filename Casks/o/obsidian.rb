cask "obsidian" do
  version "1.5.12"
  sha256 "31226617959d7716c2fd2ef0da75a3943c6de473d40c2a11170276319307f4ab"

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