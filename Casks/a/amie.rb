cask "amie" do
  arch arm: "-arm64"

  version "240918.0.1"
  sha256 arm:   "e2aacb51994880d711d77b0e40a2e6856d64598263d36f73f24d479b2a12423a",
         intel: "d44ed9178d04490adaacc23549322f449381c50f0d430b25fee5c87bc942466f"

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