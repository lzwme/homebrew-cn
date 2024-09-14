cask "responsively" do
  arch arm: "-arm64"

  version "1.15.0"
  sha256 arm:   "50c8bdfae88eaed22f494403603b2d0782cbe1f06b48866d7a49067a64d485ee",
         intel: "362ef7061db79143b56e5e57756ace40b0ef25b8a25f1333a3df77f28af6182f"

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