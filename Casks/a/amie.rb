cask "amie" do
  arch arm: "-arm64"

  version "240515.0.0"
  sha256 arm:   "aafba46681b178d621f0fde7763345fc33f9b5b0665c7433a014101c902bd6bc",
         intel: "1bdc9ba3186b8bb87af502c0bd91c543826b3563ccfb91c7b1ad1948a2bd2bf8"

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