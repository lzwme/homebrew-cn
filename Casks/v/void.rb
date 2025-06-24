cask "void" do
  arch arm: "arm64", intel: "x64"

  version "1.99.30044"
  sha256 arm:   "fa066d553093c1c9b92e7cae0754c14cfa6e1cbdb958139a5b02569dd1d9e877",
         intel: "10f0a93722e3eacfd34d59bb7ecdd3300cc4493cf8bc7771be7db4a9678881f0"

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