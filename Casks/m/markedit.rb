cask "markedit" do
  version "1.16.1"
  sha256 "50eafa942d3cc3fce451a113d6b3da42dc092e49a506686517709f84585f77fa"

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