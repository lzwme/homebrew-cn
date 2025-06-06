cask "void" do
  arch arm: "arm64", intel: "x64"

  version "1.99.30037"
  sha256 arm:   "d3edf0c8598b1c8ddd8189211ca45ba5659886154d65c8f80c4a84379d14fff6",
         intel: "8788b56a1877a62971c8b446539edb127a1d2259a01b79b37f1e76cbfd046deb"

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