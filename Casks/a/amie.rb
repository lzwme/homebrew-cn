cask "amie" do
  arch arm: "-arm64"

  version "240902.0.0"
  sha256 arm:   "6b65ef7b785c53f0aa35549b6884d3df85bde1d6805d67ba7ca0250b22217298",
         intel: "884d703154b019a3569c82247d619d2186ed022013b5c850fe3d7f6e6110d935"

  url "https:github.comamiesoelectron-releasesreleasesdownloadv#{version}Amie-#{version}#{arch}-mac.zip",
      verified: "github.comamiesoelectron-releases"
  name "Amie"
  desc "Calendar and task manager"
  homepage "https:amie.so"

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Amie.app"

  zap trash: [
    "~LibraryApplication Supportamie-desktop",
    "~LibraryCachesamie-desktop",
    "~LibraryLogsamie-desktop",
    "~LibraryPreferencesso.amie.electron-app.plist",
    "~LibrarySaved Application Stateso.amie.electron-app.savedState",
  ]
end