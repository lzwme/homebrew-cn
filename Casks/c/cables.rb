cask "cables" do
  arch arm: "-arm64", intel: "-x64"

  version "0.4.0"
  sha256 arm:   "1c5b96aff957f4de6900112457a9fcaf4d1d30f600be9c4f397353f76dc635d6",
         intel: "34090e223a8599c31945ae3b3c0090def8883566d2d9063e960de62c00aeea64"

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