cask "remnote" do
  arch arm: "-arm64"

  version "1.23.9"
  sha256 arm:   "7ae758843a87381bdebc595882423f728af3db1bdd6c589f0aab14f883050dab",
         intel: "db14ce75e5bec9050c17aa595521626dda5639f7532ecdc95aa9c89ea0672c4c"

  url "https://download2.remnote.io/remnote-desktop2/RemNote-#{version}#{arch}-mac.zip",
      verified: "download2.remnote.io/"
  name "RemNote"
  desc "Spaced-repetition powered note-taking tool"
  homepage "https://www.remnote.com/"

  livecheck do
    url "https://download2.remnote.io/remnote-desktop2/latest-mac.yml"
    strategy :electron_builder
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "RemNote.app"

  zap trash: [
    "~/Library/Application Support/RemNote",
    "~/Library/Preferences/io.remnote.plist",
    "~/Library/Saved Application State/io.remnote.savedState",
  ]
end