cask "mac-mouse-fix" do
  version "3.0.4"
  sha256 "c9a8020cf7bfd1e319e1223590650dc65d9f1b4799f669e45c71ac556f21b741"

  url "https:github.comnoah-nueblingmac-mouse-fixreleasesdownload#{version}MacMouseFixApp.zip",
      verified: "github.comnoah-nueblingmac-mouse-fix"
  name "Mac Mouse Fix"
  desc "Mouse utility to add gesture functions and smooth scrolling to 3rd party mice"
  homepage "https:macmousefix.com"

  livecheck do
    url "https:raw.githubusercontent.comnoah-nueblingmac-mouse-fixupdate-feedappcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  conflicts_with cask: "mac-mouse-fix@2"
  depends_on macos: ">= :mojave"

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