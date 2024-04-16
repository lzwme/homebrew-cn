cask "amie" do
  arch arm: "-arm64"

  version "240415.0.0"
  sha256 arm:   "69b4f84985b4ca01cbe4fea08105d412349ac53419bc8478be395fffe0348033",
         intel: "42a9fdfa824dad7c55f0f24b36eda55122743a3dc4889a504dd8aa3946c69986"

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