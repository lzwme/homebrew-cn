cask "aria2d" do
  version "1.3.8"
  sha256 "f541b792ed813fa38ec72a87f42e8283383c781d0c9deac421bbc1cdababbb65"

  url "https:raw.githubusercontent.comxjbetaAppUpdaterAppcastsmasterAria2DAria2D%20#{version}.dmg",
      verified: "githubusercontent.comxjbeta"
  name "Aria2D"
  desc "Aria2 GUI"
  homepage "https:github.comxjbetaAria2D"

  # Older items in the Sparkle feed may have a newer pubDate, so it's necessary
  # to work with all of the items in the feed (not just the newest one).
  livecheck do
    url "https:raw.githubusercontent.comxjbetaAppUpdaterAppcastsmasterAria2DAppcast.xml"
    strategy :sparkle do |items|
      items.map(&:short_version)
    end
  end

  depends_on macos: ">= :high_sierra"

  app "Aria2D.app"

  zap trash: [
    "~LibraryApplication SupportAria2D",
    "~LibraryApplication Supportcom.xjbeta.Aria2D",
    "~LibraryPreferencescom.xjbeta.Aria2D.plist",
    "~LibrarySaved Application Statecom.xjbeta.Aria2D.savedState",
  ]
end