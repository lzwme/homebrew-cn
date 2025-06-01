cask "blankie" do
  version "1.0.11"
  sha256 "7bdf77de1086c32b533473a6a7642c50c4784d0b5a9d645428830a86c620fafc"

  url "https:github.comcodybromblankiereleasesdownloadv#{version}Blankie.zip",
      verified: "github.comcodybromblankie"
  name "Blankie"
  desc "Ambient sound mixer for creating custom soundscapes"
  homepage "https:blankie.rest"

  depends_on macos: ">= :sonoma"

  app "Blankie.app"

  zap trash: [
    "~LibraryApplication SupportBlankie",
    "~LibraryCachescom.codybrom.blankie",
    "~LibraryContainerscom.codybrom.Blankie",
    "~LibraryPreferencescom.codybrom.blankie.plist",
    "~LibrarySaved Application Statecom.codybrom.blankie.savedState",
  ]
end