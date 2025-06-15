cask "torrent-file-editor" do
  version "1.0.0"
  sha256 "c815da8676388b30db7a2bb5e6691df72519b543eb3f5785ba13f39f658acb14"

  url "https:github.comtorrent-file-editortorrent-file-editorreleasesdownloadv#{version}torrent-file-editor-#{version}.dmg",
      verified: "github.comtorrent-file-editortorrent-file-editor"
  name "Torrent File Editor"
  desc "GUI for editing and creating torrent files"
  homepage "https:torrent-file-editor.github.io"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :sierra"

  app "Torrent File Editor.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsnet.sourceforge.torrent-file-editor.sfl*",
    "~LibraryCachesnet.sourceforge.torrent-file-editor",
    "~LibraryCookiesnet.sourceforge.torrent-file-editor.binarycookies",
    "~LibraryPreferencesnet.sourceforge.torrent-file-editor.plist",
    "~LibrarySaved Application Statenet.sourceforge.torrent-file-editor.savedState",
  ]

  caveats do
    requires_rosetta
  end
end