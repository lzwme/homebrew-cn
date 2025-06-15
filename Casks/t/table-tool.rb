cask "table-tool" do
  version "1.2.1"
  sha256 "e405f5aff5b74a8bb57f9e7dbc483a47d9c7d3d2ef095728d04e030e84017de1"

  url "https:github.comjakobTableToolreleasesdownloadv#{version}tabletool-#{version}.zip"
  name "Table Tool"
  desc "CSV file editor"
  homepage "https:github.comjakobTableTool"

  no_autobump! because: :requires_manual_review

  app "Table Tool.app"

  zap trash: [
    "~LibraryApplication Scriptsat.eggerapps.tabletool",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsat.eggerapps.tabletool.sfl*",
    "~LibraryContainersat.eggerapps.tabletool",
  ]

  caveats do
    requires_rosetta
  end
end