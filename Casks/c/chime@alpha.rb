cask "chime@alpha" do
  version "3.0.0,205"
  sha256 "c81932326b5b1a063c4540c03dff0a50acc6766fbc41b680b3706d2a40711db0"

  url "https:github.comChimeHQChimereleasesdownload#{version.csv.second}Chime.zip",
      verified: "github.comChimeHQChime"
  name "Chime"
  desc "Text and code editor"
  homepage "https:www.chimehq.com"

  livecheck do
    url "https:updates.chimehq.comcom.chimehq.Editappcast.xml"
    strategy :sparkle
  end

  auto_updates true
  conflicts_with cask: "chime"
  depends_on macos: ">= :sonoma"

  app "Chime.app"

  uninstall quit: [
    "com.chimehq.ChimeKit",
    "com.chimehq.Edit",
    "com.chimehq.Edit.*",
    "com.chimehq.EditKit",
  ]

  zap trash: [
    "~LibraryApplication Scripts*.com.chimehq.Edit",
    "~LibraryApplication Scriptscom.chimehq.Edit.*",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.chimehq.edit.sfl*",
    "~LibraryContainerscom.chimehq.Edit.*",
    "~LibraryGroup Containers*.com.chimehq.Edit",
    "~LibraryHTTPStoragescom.chimehq.Edit",
    "~LibraryPreferencescom.chimehq.Edit.plist",
  ]
end