cask "amie" do
  arch arm: "-arm64"

  version "250404.0.3"
  sha256 arm:   "48bbb83c9a9b1e34a15c35acf9615abe1f69cbc9a3ed4e60c606ddb0a0252e50",
         intel: "b80b18ade29dc89c80ad7a82494d8c86c3c76567fe119da9262bb0b94adec348"

  url "https:github.comamiesoelectron-releasesreleasesdownloadv#{version}Amie-#{version}#{arch}-mac.zip",
      verified: "github.comamiesoelectron-releases"
  name "Amie"
  desc "Calendar and task manager"
  homepage "https:amie.so"

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Amie.app"

  zap trash: [
    "~LibraryApplication Supportamie-desktop",
    "~LibraryCachesamie-desktop",
    "~LibraryLogsamie-desktop",
    "~LibraryPreferencesso.amie.electron-app.plist",
    "~LibrarySaved Application Stateso.amie.electron-app.savedState",
  ]
end