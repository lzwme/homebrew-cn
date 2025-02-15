cask "cherry-studio" do
  arch arm: "arm64", intel: "x64"

  version "0.9.24"
  sha256 arm:   "1485f5dbfb613519ecc564fd59372a97c947139ed938ae20b80a86d7ba0711cc",
         intel: "3b8ae0587639fc726d0ea7145452d39d3bcb564ebe354251ad046c93537daa85"

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