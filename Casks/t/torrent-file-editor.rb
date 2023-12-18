cask "torrent-file-editor" do
  version "0.3.18"
  sha256 "55ac51bea3df120b236b438f0eab78ba144a7217ae98a67f86e1343e76e366b7"

  url "https:github.comtorrent-file-editortorrent-file-editorreleasesdownloadv#{version}torrent-file-editor-#{version}.dmg",
      verified: "github.comtorrent-file-editortorrent-file-editor"
  name "Torrent File Editor"
  desc "GUI for editing and creating torrent files"
  homepage "https:torrent-file-editor.github.io"

  depends_on macos: ">= :sierra"

  app "Torrent File Editor.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsnet.sourceforge.torrent-file-editor.sfl*",
    "~LibraryCachesnet.sourceforge.torrent-file-editor",
    "~LibraryCookiesnet.sourceforge.torrent-file-editor.binarycookies",
    "~LibraryPreferencesnet.sourceforge.torrent-file-editor.plist",
    "~LibrarySaved Application Statenet.sourceforge.torrent-file-editor.savedState",
  ]
end