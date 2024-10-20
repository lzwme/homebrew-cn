cask "markedit" do
  version "1.20.1"
  sha256 "292edcf5a18bbcbf1b8a4a1f75790018fddaca459367a2acb35b9cb26f1624e1"

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