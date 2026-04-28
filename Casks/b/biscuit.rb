cask "biscuit" do
  arch arm: "-arm64"

  version "2.1.0"
  sha256 arm:   "fadc4331a884649c895b5fd999570464b165e0b7e139989fc6dc8b4592964af8",
         intel: "1723af1bd0e3feb0fbf0d4b0c14b7f00be92ae8bf51a63ade4e021d66a81f74d"

  url "https://ghfast.top/https://github.com/agata/dl.biscuit/releases/download/#{version}/Biscuit-#{version}#{arch}.dmg",
      verified: "github.com/agata/dl.biscuit/"
  name "Biscuit"
  desc "Browser to organise apps"
  homepage "https://eatbiscuit.com/"

  auto_updates true
  depends_on macos: ">= :monterey"

  app "Biscuit.app"

  zap trash: [
    "~/Library/Application Support/biscuit",
    "~/Library/Logs/Biscuit",
    "~/Library/Preferences/com.eatbiscuit.biscuit.plist",
    "~/Library/Saved Application State/com.eatbiscult.biscult.savedState",
  ]
end