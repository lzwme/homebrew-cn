cask "remnote" do
  arch arm: "-arm64"
  livecheck_arch = on_arch_conditional arm: "_m1"

  version "1.26.0"
  sha256 arm:   "df6889db459db6780060af6f901aac1c4f39cecfa3527d82248df0e386643804",
         intel: "c7e25ea1b1777bf836debb91511b7dd44f271eff71eadfc52bccd6809173dccb"

  url "https://download2.remnote.io/remnote-desktop2/RemNote-#{version}#{arch}-mac.zip",
      verified: "download2.remnote.io/"
  name "RemNote"
  desc "Spaced-repetition powered note-taking tool"
  homepage "https://www.remnote.com/"

  livecheck do
    url "https://backend.remnote.com/desktop/mac#{livecheck_arch}"
    regex(/RemNote[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :header_match
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