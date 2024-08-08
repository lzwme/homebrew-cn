cask "cables" do
  arch arm: "-arm64", intel: "-x64"

  version "0.2.0"
  sha256 arm:   "3f78eb052b2e6ee47ba03b517b80fafa8c737e0d59dce6ebd888b87269e34731",
         intel: "22104e4e8ba027aa5dcb063b616988c32acff3da5b273705798382b63a7d4a75"

  url "https:github.comcables-glcables_electronreleasesdownloadv#{version}cables-#{version}-mac#{arch}.dmg"
  name "Cables"
  desc "Visual programming tool"
  homepage "https:github.comcables-glcables_electron"

  livecheck do
    url "https:dev.cables.glapidownloadslatest"
    strategy :json do |json|
      json["name"]
    end
  end

  depends_on macos: ">= :catalina"

  app "cables-#{version}.app"

  zap trash: [
    "~LibraryApplication Supportcables_electron",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsgl.cables.standalone.sfl*",
    "~LibraryLogscables_electron",
    "~LibraryPreferencesgl.cables.standalone.plist",
    "~LibrarySaved Application Stategl.cables.standalone.savedState",
  ]
end