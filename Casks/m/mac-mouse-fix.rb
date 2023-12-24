cask "mac-mouse-fix" do
  version "3.0.0"
  sha256 "e79c8feb18685e87bcb63bd4207ae593e93f45ff1fd319825222c6c17bb643df"

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