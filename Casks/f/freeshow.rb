cask "freeshow" do
  arch arm: "arm64", intel: "x64"

  version "1.4.5"
  sha256 arm:   "dbb099331e22f19950a832f7a620dc6cc39d0ab126cc3a02d7ad899ce8644ab0",
         intel: "4dd3a5c03a0a8cc032285bde9609a81bbfc4d8ab595a3681d4391a31b3c6aeaa"

  url "https:github.comChurchAppsFreeShowreleasesdownloadv#{version}FreeShow-#{version}-#{arch}.zip",
      verified: "github.comChurchApps"
  name "FreeShow"
  desc "Presentation software"
  homepage "https:freeshow.app"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "FreeShow.app"

  zap trash: [
        "~LibraryApplication Supportfreeshow",
        "~LibraryPreferencesapp.freeshow.plist",
        "~LibrarySaved Application Stateapp.freeshow.savedState",
      ],
      rmdir: "~DocumentsFreeShow"
end