cask "markedit" do
  version "1.25.0"
  sha256 "9a02c7d1bdff092620cf74dd70b4602eff0efc54d633efc9445000c3ad96f829"

  url "https:github.comMarkEdit-appMarkEditreleasesdownloadv#{version}MarkEdit-#{version}.dmg"
  name "MarkEdit"
  desc "Markdown editor"
  homepage "https:github.comMarkEdit-appMarkEdit"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :sonoma"

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