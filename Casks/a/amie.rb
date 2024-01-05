cask "amie" do
  arch arm: "-arm64"

  version "240104.0.0"
  sha256 arm:   "3db0d24e667bca5bdf0648b3a9cb8d3fdbb6a409b389e9f64265a7ae6cf1cfdf",
         intel: "2b5bd26122847a6d8845cafd1246e68e79fdb2cb8a47f8a3517b542a2cc1f52f"

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