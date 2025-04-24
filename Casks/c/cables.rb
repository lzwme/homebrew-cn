cask "cables" do
  arch arm: "-arm64", intel: "-x64"

  version "0.5.12"
  sha256 arm:   "ab0b83112981dd2bb5f98462aec4ba22f9c2adf4109a4aa3828cc3473f9d39b0",
         intel: "3b02a44365eed28ba3268be28410ecafaa6f297000cde95e521493ee21aeba7f"

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