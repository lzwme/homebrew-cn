cask "xcodepilot" do
  version "1.4.0,23"
  sha256 "936a8a38cad857260e510cd35c0d87bc801aa5c1f48cc564933a94217de7f752"

  url "https://xcodepilot.thriller.fun/packages/appcast/XcodePilot.v#{version.csv.first}_#{version.csv.second}.zip"
  name "XcodePilot"
  desc "Toolset for Apple developers to increase productivity and efficiency"
  homepage "https://xcodepilot.thriller.fun/"

  livecheck do
    url "https://xcodepilot.thriller.fun/packages/appcast/appcast.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on macos: ">= :ventura"

  app "XcodePilot.app"

  uninstall quit: "fun.thriller.XcodePilot"

  zap trash: [
    "~/Library/Application Support/fun.thriller.XcodePilot",
    "~/Library/Caches/fun.thriller.XcodePilot",
    "~/Library/Containers/org.sparkle-project.Downloader/Data/Library/Caches/fun.thriller.XcodePilot",
    "~/Library/Group Containers/V63R5GQ252.group.fun.thriller.xcode.pilot",
    "~/Library/Preferences/fun.thriller.XcodePilot.plist",
    "~/Library/WebKit/fun.thriller.XcodePilot",
  ]
end