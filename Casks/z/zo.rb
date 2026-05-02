cask "zo" do
  version "1.5.1"
  sha256 "e7241eabbdbaf610673ebe172a4c25b3f4802b197178c10a428df71cff4d370b"

  url "https://ghfast.top/https://github.com/zocomputer/Zo/releases/download/v#{version}/Zo-#{version}-universal-mac.zip",
      verified: "github.com/zocomputer/Zo/"
  name "Zo"
  desc "Friendly personal server"
  homepage "https://www.zo.computer/"

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Zo.app"

  zap trash: [
    "~/Library/Application Support/Zo",
    "~/Library/Preferences/computer.zo.desktop.plist",
  ]
end