cask "void" do
  arch arm: "arm64", intel: "x64"

  version "1.99.30033"
  sha256 arm:   "9f61dbe001e561447c1666a4f7008cbe3d6f27e94017f45eda69db971ac71d68",
         intel: "67044af2ec463cef2c63429feefb08e4cb154e47614c08699de0b5f96e5c6402"

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