cask "xcodepilot" do
  version "1.5.0,27"
  sha256 "3de58f7b2ef6f19d6a4202421dfdfe8ec9a1456e7e0c170871725969c064c15b"

  url "https:raw.githubusercontent.comTMTBOXcodePilotPagesrefsheadsmaindocspackagesappcastXcodePilot.v#{version.csv.first}_#{version.csv.second}.zip",
      verified: "raw.githubusercontent.comTMTBOXcodePilotPages"
  name "XcodePilot"
  desc "Toolset for Apple developers to increase productivity and efficiency"
  homepage "https:xcodepilot.thriller.fundocs"

  livecheck do
    url "https:raw.githubusercontent.comTMTBOXcodePilotPagesrefsheadsmaindocspackagesappcastappcast.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on macos: ">= :ventura"

  app "XcodePilot.app"

  uninstall quit: "fun.thriller.XcodePilot"

  zap trash: [
    "~LibraryApplication Supportfun.thriller.XcodePilot",
    "~LibraryCachesfun.thriller.XcodePilot",
    "~LibraryContainersorg.sparkle-project.DownloaderDataLibraryCachesfun.thriller.XcodePilot",
    "~LibraryGroup ContainersV63R5GQ252.group.fun.thriller.xcode.pilot",
    "~LibraryPreferencesfun.thriller.XcodePilot.plist",
    "~LibraryWebKitfun.thriller.XcodePilot",
  ]
end