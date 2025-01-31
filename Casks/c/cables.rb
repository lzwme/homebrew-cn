cask "cables" do
  arch arm: "-arm64", intel: "-x64"

  version "0.5.5"
  sha256 arm:   "52439be9cbe013b50106d993b4721500cb5bd0056634f11ee1ad08b8e3f38e79",
         intel: "2e742b4fdd6e4341585a719f19c92cef57c01b3c8a89c9dafcf931a52d695f6a"

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