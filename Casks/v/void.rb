cask "void" do
  arch arm: "arm64", intel: "x64"

  version "1.99.30039"
  sha256 arm:   "f0e38cb00fc43ccc4719a9860c4da7d02851f71497e3c47f095b2bc71cfed81d",
         intel: "b71729eedba65487acee1166157ed2295a026f3bef13ebced1ed505039b9b98e"

  url "https:github.comvoideditorbinariesreleasesdownload#{version}Void.#{arch}.#{version}.dmg",
      verified: "github.comvoideditor"
  name "Void"
  desc "AI code editor"
  homepage "https:voideditor.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Void.app"
  binary "#{appdir}Void.appContentsResourcesappbinvoid"

  zap trash: [
    "~LibraryApplication SupportVoid",
    "~LibraryCachescom.voideditor.Void",
    "~LibraryPreferencescom.voideditor.Void.plist",
    "~LibrarySaved Application Statecom.voideditor.Void.savedState",
  ]
end