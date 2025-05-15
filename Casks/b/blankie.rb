cask "blankie" do
  version "1.0.6"
  sha256 "feb5f1599598dbefc100305dd60668b1969509eef57512dade1dc4f3216c42e9"

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