cask "amie" do
  arch arm: "-arm64"

  version "240916.0.0"
  sha256 arm:   "027ae73c8d598eaebfd22dba341da2ac19eaa8785d0fd21a83dde3591eb89eff",
         intel: "aa6e626d96fcfbff094a91ed2fe6dd59ba350d857f761f556a303dadb3234b36"

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