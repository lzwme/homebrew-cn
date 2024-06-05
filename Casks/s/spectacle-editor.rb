cask "spectacle-editor" do
  version "0.1.6"
  sha256 "5dc93387bc6026dd44dbf2f88c9bf7730d931663d5b72f382c0a51bc6c57517b"

  url "https:github.complotlyspectacle-editorreleasesdownloadv#{version}Spectacle.Editor-#{version}.dmg"
  name "Spectacle Editor"
  desc "Drag and drop Spectacle editor"
  homepage "https:github.complotlyspectacle-editor"

  disable! date: "2024-06-03", because: :no_longer_available

  app "Spectacle Editor.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.formidable.spectacle-editor.sfl*",
    "~LibraryApplication SupportSpectacle Editor",
    "~LibraryPreferencescom.formidable.spectacle-editor.plist",
  ]
end