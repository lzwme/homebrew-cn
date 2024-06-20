cask "amie" do
  arch arm: "-arm64"

  version "240618.0.3"
  sha256 arm:   "0cbd3bd18dbdf1d3d885ccb08f24a4005c565995cb6c3f676f1173b2d70ab347",
         intel: "cec357587d47f37b9c6e779b81b9836886dc86723b68f322d5be996637698d5d"

  url "https:github.comamiesoelectron-releasesreleasesdownloadv#{version}Amie-#{version}#{arch}-mac.zip",
      verified: "github.comamiesoelectron-releases"
  name "Amie"
  desc "Calendar and task manager"
  homepage "https:amie.so"

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Amie.app"

  zap trash: [
    "~LibraryApplication Supportamie-desktop",
    "~LibraryCachesamie-desktop",
    "~LibraryLogsamie-desktop",
    "~LibraryPreferencesso.amie.electron-app.plist",
    "~LibrarySaved Application Stateso.amie.electron-app.savedState",
  ]
end