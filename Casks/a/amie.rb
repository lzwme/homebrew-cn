cask "amie" do
  arch arm: "-arm64"

  version "241024.0.0"
  sha256 arm:   "d19e6dd2e15520f61b0e698cfe644d9fd8e87e4b901fd25401b5bdcf463df78c",
         intel: "461134f03a68690ca74de54ea7b4081fcc7d17c23b23451fff448a3d1111189e"

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