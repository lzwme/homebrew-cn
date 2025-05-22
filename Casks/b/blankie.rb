cask "blankie" do
  version "1.0.8"
  sha256 "647b9a4da75af0bf4d4bb8a7bb05322fa59efe6fc2913acb05bb05097510e7ca"

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