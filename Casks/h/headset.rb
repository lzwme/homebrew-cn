cask "headset" do
  arch arm: "arm64", intel: "x64"

  version "4.2.1"
  sha256 arm:   "073fb9b79225d516edf380fc2128083fcb8773e39d50e99cc4b9f9ea8ff33a68",
         intel: "a46fde8dfebbe4e4d19a5645e79b80954f1d26e2b58696e57383b94d36a140f3"

  url "https:github.comheadsetappheadset-electronreleasesdownloadv#{version}Headset-#{version}-mac-#{arch}.zip",
      verified: "github.comheadsetappheadset-electron"
  name "Headset"
  desc "Music player powered by YouTube and Reddit"
  homepage "https:headsetapp.co"

  app "buildheadset-darwin-#{arch}Headset.app"

  zap trash: [
    "~LibraryApplication SupportHeadset",
    "~LibraryCachesco.headsetapp.app",
    "~LibraryCachesco.headsetapp.app.ShipIt",
    "~LibraryCookiesco.headsetapp.app.binarycookies",
    "~LibraryLogsHeadset",
    "~LibraryPreferencesByHostco.headsetapp.app.ShipIt.*.plist",
    "~LibraryPreferencesco.headsetapp.app.plist",
    "~LibrarySaved Application Stateco.headsetapp.app.savedState",
  ]
end