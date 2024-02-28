cask "amie" do
  arch arm: "-arm64"

  version "240227.0.0"
  sha256 arm:   "ef326d106d4c5cc557bb757fca7a052389405b351c6dc89b9c662ce1033b245c",
         intel: "678e2e06193715c98eac56989242127981017cca3c8aa3ac3d6f4b0590731f8f"

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