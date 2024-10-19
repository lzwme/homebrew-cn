cask "xcodes" do
  version "2.3.0b28"
  sha256 "9ded84e8da5006e7e9e282c765290f0a5ab15a5e0d960e86125339e6ae63661e"

  url "https:github.comXcodesOrgXcodesAppreleasesdownloadv#{version}Xcodes.zip"
  name "Xcodes"
  desc "Install and switch between multiple versions of Xcode"
  homepage "https:github.comXcodesOrgXcodesApp"

  auto_updates true
  depends_on macos: ">= :ventura"

  app "Xcodes.app"

  zap trash: [
    "LibraryPrivilegedHelperToolscom.robotsandpencils.XcodesApp.Helper",
    "~LibraryApplication Supportcom.robotsandpencils.XcodesApp",
  ]
end