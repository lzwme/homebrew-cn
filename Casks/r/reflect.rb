cask "reflect" do
  arch arm: "arm64", intel: "x64"

  version "3.0.1"
  sha256 arm:   "94df679b6cb0cd195abe0fdc0e32a50d394f6e076a5496f21a70e75532723e8e",
         intel: "e79c6bdb4ac7f5291ee7fdb90be1923c8effca2d3739c974e88334cb7d524969"

  url "https:github.comteam-reflectreflect-electron-updatesreleasesdownloadv#{version}Reflect-darwin-#{arch}-#{version}.zip",
      verified: "github.comteam-reflectreflect-electron-updates"
  name "Reflect Notes"
  desc "Note taking app for meetings, ideas, journalling, and research"
  homepage "https:reflect.app"

  auto_updates true

  app "Reflect.app"

  zap trash: [
    "~LibraryApplication SupportReflect",
    "~LibraryPreferencesapp.reflect.ReflectDesktop.plist",
  ]
end