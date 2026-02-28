cask "znote" do
  arch arm: "-arm64"

  version "3.6.5"
  sha256 arm:   "22cc173a425b92040ca1653e3455218627ee2ccb00f66e6ca12754fd2edb26b5",
         intel: "06c1ef91ddf9405e9c0f220a4d05577bc5a4a85f5910192071b0d4a69f910428"

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