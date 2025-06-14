cask "chainner" do
  version "0.24.1"
  sha256 "260400471ea1eac0f22bc11f5556170df26a8248eab3f36d173b07d5524700f4"

  url "https:github.comchaiNNer-orgchaiNNerreleasesdownloadv#{version}chaiNNer-#{version}-universal-macos.dmg",
      verified: "github.comchaiNNer-orgchaiNNer"
  name "chaiNNer"
  desc "Flowchart-based image processing GUI"
  homepage "https:chainner.app"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

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