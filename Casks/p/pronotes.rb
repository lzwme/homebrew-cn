cask "pronotes" do
  version "0.7.6"
  sha256 "655cd62f286539610c0523fee835ac5f3dcccd74bb9d63e245ee51f5a898e8f5"

  url "https://assets.pronotes.app/downloads/ProNotes-#{version}.zip"
  name "ProNotes"
  desc "Apple Notes extension"
  homepage "https://www.pronotes.app/"

  livecheck do
    url "https://www.pronotes.app/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :ventura"

  app "ProNotes.app"

  zap trash: [
    "~/Library/Caches/com.dexterleng.ProNotes",
    "~/Library/Preferences/com.dexterleng.ProNotes.plist",
    "~/Library/Saved Application State/com.dexterleng.ProNotes.savedState",
    "~/Library/WebKit/com.dexterleng.ProNotes",
  ]
end