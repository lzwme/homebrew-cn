cask "markedit" do
  version "1.16.0"
  sha256 "7ebfc7fbbb5e2c53cfdea1e47a021997b3037044b7b4a418173f3c82eb7f40df"

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