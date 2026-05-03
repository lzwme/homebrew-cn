cask "znote" do
  arch arm: "-arm64"

  version "3.8.0"
  sha256 arm:   "892be63d4f4a10a8585c73fa93cc41efd93b5e6c0dada31e10fb0395a3bd9e7c",
         intel: "2649ebbb5a92ffeb36323b1b82975433eed2e7fd650b806c439aa39539f3ed4a"

  url "https://ghfast.top/https://github.com/alagrede/znote-app/releases/download/v#{version}/znote-#{version}#{arch}.dmg",
      verified: "github.com/alagrede/znote-app/"
  name "Znote"
  desc "Notes-taking app"
  homepage "https://znote.io/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "znote.app"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.tony.znote.sfl*",
    "~/Library/Application Support/znote",
    "~/Library/Preferences/com.tony.znote.plist",
    "~/Library/Saved Application State/com.tony.znote.savedState",
  ]
end