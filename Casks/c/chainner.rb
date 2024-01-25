cask "chainner" do
  version "0.21.2"
  sha256 "a56afa9f9c8959c839a12c53af8cfccd209e4d40a8fcb7fc77a990bdb6585ea9"

  url "https:github.comchaiNNer-orgchaiNNerreleasesdownloadv#{version}chaiNNer-#{version}-universal-macos.dmg",
      verified: "github.comchaiNNer-orgchaiNNer"
  name "chaiNNer"
  desc "Flowchart-based image processing GUI"
  homepage "https:chainner.app"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "chaiNNer.app"

  zap trash: [
    "~LibraryApplication SupportchaiNNer",
    "~LibraryCacheschainner_pip",
    "~LibraryLogschaiNNer",
    "~LibraryPreferencescom.electron.chainner.plist",
    "~LibrarySaved Application Statecom.electron.chainner.savedState",
  ]
end