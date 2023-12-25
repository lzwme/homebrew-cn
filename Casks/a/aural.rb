cask "aural" do
  version "3.25.1"
  sha256 "018378b99e532d57e1f466c4b23e0f912b768ab21ccc0d4cbdb90e038d4df708"

  url "https:github.commaculateConceptionaural-playerreleasesdownloadv#{version}AuralPlayer-#{version}.dmg"
  name "Aural Player"
  desc "Audio player inspired by Winamp"
  homepage "https:github.commaculateConceptionaural-player"

  depends_on macos: ">= :high_sierra"

  app "Aural.app"

  zap trash: "~LibraryPreferencesanon.Aural.plist"
end