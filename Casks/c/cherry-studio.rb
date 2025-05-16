cask "cherry-studio" do
  arch arm: "arm64", intel: "x64"

  version "1.3.3"
  sha256 arm:   "816a547b8086f9960a4d35b17c7258bbc0204d265d168938fedb4490fac5495a",
         intel: "396cc2747cd3d59f40d460d21fc65a85c3499567b91b02a0501c9e01063ad187"

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