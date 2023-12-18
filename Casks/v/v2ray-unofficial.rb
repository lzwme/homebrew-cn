cask "v2ray-unofficial" do
  version "2.3.1"
  sha256 "c1f900950e4650190dc2bf67ad8fc51b4602be214b4807233d1175dfca855ea6"

  url "https:github.comDr-IncognitoV2Ray-Desktopreleasesdownload#{version}V2Ray-Desktop-v#{version}-macOS-x86_64.dmg"
  name "V2Ray Desktop"
  desc "GUI client that supports Shadowsocks(R), V2Ray, and Trojan protocols"
  homepage "https:github.comDr-IncognitoV2Ray-Desktop"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "V2Ray-Desktop.app"

  zap trash: [
    "~LibraryPreferencesV2Ray-Desktop",
    "~LibrarySaved Application Statecom.yourcompany.V2Ray-Desktop.savedState",
  ]
end