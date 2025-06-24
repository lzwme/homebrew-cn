cask "xcodes-app" do
  version "2.4.2b31"
  sha256 "6663d97f7cde4feea9f776e5cff89c47f89c734517c08eee58d3d76a7a67b6c1"

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