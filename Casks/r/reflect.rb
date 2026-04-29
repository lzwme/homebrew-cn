cask "reflect" do
  version "3.3.0"
  sha256 "75561e61839e266c03e21c48548e7f9bfa2dfcd6aa2b7ea0b20e448bf073c9e5"

  url "https://ghfast.top/https://github.com/team-reflect/reflect-electron-updates/releases/download/v#{version}/Reflect-darwin-universal-#{version}.zip",
      verified: "github.com/team-reflect/reflect-electron-updates/"
  name "Reflect Notes"
  desc "Note taking app for meetings, ideas, journalling, and research"
  homepage "https://reflect.app/"

  auto_updates true
  depends_on macos: ">= :monterey"

  app "Reflect.app"

  zap trash: [
    "~/Library/Application Support/Reflect",
    "~/Library/Preferences/app.reflect.ReflectDesktop.plist",
  ]
end