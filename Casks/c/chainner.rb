cask "chainner" do
  version "0.22.1"
  sha256 "19080a54aeee6dc9c9ac20fcc679672b51e53a4d7ca22e8f3ea496c818791813"

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