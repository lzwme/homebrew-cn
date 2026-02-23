cask "reflect" do
  version "3.1.11"
  sha256 "d360c2b040c8663e91957091938d32c60b491011509ce80d1eb43fb454a4ec5e"

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