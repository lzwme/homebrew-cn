cask "mac-mouse-fix" do
  version "3.0.2"
  sha256 "b839288d5a2bb14042dc40405d1c826c0e9efad424da37ed3e2482d87c21f21d"

  url "https:github.comnoah-nueblingmac-mouse-fixreleasesdownload#{version}MacMouseFixApp.zip",
      verified: "github.comnoah-nueblingmac-mouse-fix"
  name "Mac Mouse Fix"
  desc "Mouse utility to add gesture functions and smooth scrolling to 3rd party mice"
  homepage "https:noah-nuebling.github.iomac-mouse-fix-website"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  app "Mac Mouse Fix.app"

  zap trash: [
    "~LibraryApplication Supportcom.nuebling.mac-mouse-fix",
    "~LibraryLaunchAgentscom.nuebling.mac-mouse-fix.helper.plist",
  ]
end