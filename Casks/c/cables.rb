cask "cables" do
  arch arm: "-arm64", intel: "-x64"

  version "0.5.17"
  sha256 arm:   "750f901bf01ba1a2e7d1d5cd08945cb59b42242fe8a189a93496d0effcd130a8",
         intel: "aa07cfcdabcdceaf9e5b3bc314df98b2c01681719665a9d64629364aa408e996"

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