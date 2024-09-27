cask "amie" do
  arch arm: "-arm64"

  version "240926.0.0"
  sha256 arm:   "662b27152412e52f347a54d78ef00baf7f0f655e0842dea4a769d863890c3bbf",
         intel: "13733f8d2e4534cb38400aab21804b4b4457d8d56a9805a64e13ded0cb268e83"

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