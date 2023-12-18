cask "vincelwt-chatgpt" do
  arch arm: "arm64", intel: "x64"

  version "0.0.5"
  sha256 arm:   "e41a76560d78afd5000129aeb4d720c755bf916c7db32c81f608c5ee5bd3177a",
         intel: "f2c1bbe1e37836e9615e0061fd41d16c2ab16e60440aee3af4f62f8d346ec330"

  url "https:github.comvincelwtchatgpt-macreleasesdownloadv#{version}Chatgpt-#{version}-#{arch}.dmg"
  name "ChatGPT for Mac"
  desc "Menu bar application for ChatGPT"
  homepage "https:github.comvincelwtchatgpt-mac"

  app "Chatgpt.app"

  zap trash: [
    "~LibraryApplication Scriptschatgpt-mac",
    "~LibraryCachescom.vincelwt.chatgptmac",
    "~LibraryCachescom.vincelwt.chatgptmac.ShipIt",
    "~LibraryPreferencescom.vincelwt.chatgptmac.plist",
  ]
end