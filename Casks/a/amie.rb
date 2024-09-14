cask "amie" do
  arch arm: "-arm64"

  version "240911.0.7"
  sha256 arm:   "e3102a075054ceb17da2f942421882a48294a857596687235379e400ff32f109",
         intel: "efd65399d7481706d820ede41222ef74bc35f378062c82a3351788ec9b04f06b"

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