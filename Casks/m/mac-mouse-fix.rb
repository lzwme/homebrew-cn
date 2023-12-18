cask "mac-mouse-fix" do
  version "2.2.3"
  sha256 "6f2eea2403b97e7d045d364b28bdd3f6a85a8e3c70470e94ab4f22add2e4ce7d"

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