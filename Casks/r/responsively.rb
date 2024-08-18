cask "responsively" do
  arch arm: "-arm64"

  version "1.14.0"
  sha256 arm:   "52ae7dba4069cb59923df648b0f4d6c4b889aa41ea97f4b4ec223528bb7f124b",
         intel: "5bf6c3f058d29e855f1e0e50901083633895919fa3ea42886df5f4ff5eb49140"

  url "https:github.comresponsively-orgresponsively-app-releasesreleasesdownloadv#{version}ResponsivelyApp-#{version}#{arch}.dmg",
      verified: "github.comresponsively-orgresponsively-app-releases"
  name "Responsively"
  desc "Modified browser that helps in responsive web development"
  homepage "https:responsively.app"

  app "ResponsivelyApp.app"

  zap trash: [
    "~LibraryApplication SupportResponsivelyApp",
    "~LibraryPreferencesapp.responsively.plist",
  ]
end