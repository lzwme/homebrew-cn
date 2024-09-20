cask "mac-mouse-fix" do
  version "3.0.3"
  sha256 "6eda564bf2eb92f1cfe01d8965a9f52f1233880122c7ce401c7f25c37505f560"

  url "https:github.comnoah-nueblingmac-mouse-fixreleasesdownload#{version}MacMouseFixApp.zip",
      verified: "github.comnoah-nueblingmac-mouse-fix"
  name "Mac Mouse Fix"
  desc "Mouse utility to add gesture functions and smooth scrolling to 3rd party mice"
  homepage "https:macmousefix.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  conflicts_with cask: "mac-mouse-fix@2"
  depends_on macos: ">= :high_sierra"

  app "Mac Mouse Fix.app"

  zap trash: [
    "~LibraryApplication Supportcom.nuebling.mac-mouse-fix",
    "~LibraryCachescom.nuebling.mac-mouse-fix",
    "~LibraryCachescom.nuebling.mac-mouse-fix.helper",
    "~LibraryHTTPStoragescom.nuebling.mac-mouse-fix",
    "~LibraryHTTPStoragescom.nuebling.mac-mouse-fix.binarycookies",
    "~LibraryHTTPStoragescom.nuebling.mac-mouse-fix.helper",
    "~LibraryHTTPStoragescom.nuebling.mac-mouse-fix.helper.binarycookies",
    "~LibraryPreferencescom.nuebling.mac-mouse-fix.helper.plist",
    "~LibraryPreferencescom.nuebling.mac-mouse-fix.plist",
    "~LibraryWebKitcom.nuebling.mac-mouse-fix",
  ]
end