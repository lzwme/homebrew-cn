cask "xcodes" do
  version "2.1.2b26"
  sha256 "804bc88b85f6a068f880d2b88064fe9b87bc84012866f385f3904e96503a8c60"

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