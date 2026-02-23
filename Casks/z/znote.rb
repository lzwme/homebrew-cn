cask "znote" do
  arch arm: "-arm64"

  version "3.6.4"
  sha256 arm:   "8218c213b705c3c6880909435976e9a7af078d4ff5bd8981a437124ea30e4a79",
         intel: "5861238c7c291bfb3159b8d6fb0d8f5ab51d092a0634271699fd87cf7369fc24"

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