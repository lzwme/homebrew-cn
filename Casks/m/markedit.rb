cask "markedit" do
  version "1.19.0"
  sha256 "607f69bf59eb9286cb176a47c32ef6b3f2ad358361ce2684d98d3e8d8ee83104"

  url "https:github.comMarkEdit-appMarkEditreleasesdownloadv#{version}MarkEdit-#{version}.dmg"
  name "MarkEdit"
  desc "Markdown editor"
  homepage "https:github.comMarkEdit-appMarkEdit"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :ventura"

  app "MarkEdit.app"

  zap trash: [
    "~LibraryApplication Scriptsapp.cyan.markedit",
    "~LibraryApplication Scriptsapp.cyan.markedit.preview-extension",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsapp.cyan.markedit.sfl*",
    "~LibraryContainersapp.cyan.markedit",
    "~LibraryContainersapp.cyan.markedit.preview-extension",
    "~LibrarySaved Application Stateapp.cyan.markedit.savedState",
  ]
end