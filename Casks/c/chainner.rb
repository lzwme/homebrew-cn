cask "chainner" do
  version "0.20.2"
  sha256 "4d0cb96e14f31c40fd50310065723b288f10991d0ff20c23fb10d633111684e1"

  url "https:github.comchaiNNer-orgchaiNNerreleasesdownloadv#{version}chaiNNer-#{version}-macos-universal.dmg",
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