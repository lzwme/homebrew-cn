cask "cherry-studio" do
  arch arm: "arm64", intel: "x64"

  version "1.1.18"
  sha256 arm:   "991e362956354e085d406a8d90308bcf7a278881a1228fc32f2a8ab6bd444d13",
         intel: "5282f58df1359e80d37d6b445c681809e2a561802b1e84099d0d67ba6661de9a"

  url "https:github.comCherryHQcherry-studioreleasesdownloadv#{version}Cherry-Studio-#{version}-#{arch}.zip",
      verified: "github.comCherryHQcherry-studio"
  name "Cherry Studio"
  desc "Desktop client that supports multiple LLM providers"
  homepage "https:cherry-ai.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Cherry Studio.app"
  binary "#{appdir}Cherry Studio.appContentsMacOSCherry Studio", target: "cherry-studio"

  zap trash: [
    "~LibraryApplication SupportCherryStudio",
    "~LibraryCachescherrystudio-updater",
    "~LibraryHTTPStoragescom.kangfenmao.CherryStudio",
    "~LibraryLogsCherryStudio",
    "~LibraryPreferencescom.kangfenmao.CherryStudio.plist",
    "~LibrarySaved Application Statecom.kangfenmao.CherryStudio.savedState",
  ]
end