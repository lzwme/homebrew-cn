cask "mac-mouse-fix@2" do
  version "2.2.5"
  sha256 "ecd2bb9fc1763652bfc685a05e1adabacb5e97403d6d17bc7b3595089a0847c6"

  url "https:github.comnoah-nueblingmac-mouse-fixreleasesdownload#{version}MacMouseFixApp.zip",
      verified: "github.comnoah-nueblingmac-mouse-fix"
  name "Mac Mouse Fix"
  desc "Mouse utility to add gesture functions and smooth scrolling to 3rd party mice"
  homepage "https:macmousefix.com"

  livecheck do
    url :url
    regex(^v?(2(?:\.\d+)+)$i)
  end

  no_autobump! because: :requires_manual_review

  conflicts_with cask: "mac-mouse-fix"
  depends_on macos: ">= :high_sierra"

  app "Mac Mouse Fix.app"

  zap trash: [
    "~LibraryApplication Supportcom.nuebling.mac-mouse-fix",
    "~LibraryLaunchAgentscom.nuebling.mac-mouse-fix.helper.plist",
  ]
end