cask "cherry-studio" do
  arch arm: "arm64", intel: "x64"

  version "1.1.19"
  sha256 arm:   "eba4809a53d7acea3dcaa861989137452a8745b8204fb87e378cdbab975a226c",
         intel: "5f45eba4b1ae58f43edc9e66f463650ecdfa931df210a3a04cc8290470544449"

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