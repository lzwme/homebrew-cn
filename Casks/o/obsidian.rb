cask "obsidian" do
  version "1.8.10"
  sha256 "dc188f6d3d4c13be56a51fe64c397cfd323ecaaebe58c53e45a657ca4506f321"

  url "https:github.comobsidianmdobsidian-releasesreleasesdownloadv#{version}Obsidian-#{version}.dmg",
      verified: "github.comobsidianmd"
  name "Obsidian"
  desc "Knowledge base that works on top of a local folder of plain text Markdown files"
  homepage "https:obsidian.md"

  livecheck do
    url "https:raw.githubusercontent.comobsidianmdobsidian-releasesmasterdesktop-releases.json"
    strategy :json do |json|
      json["latestVersion"]
    end
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