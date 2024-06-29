cask "xcodes" do
  version "2.2.0b27"
  sha256 "d9afb3aef44ab5ea2f4d869ec5fd63188c16f80f17a2abe9a01eeb104c9ee05b"

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