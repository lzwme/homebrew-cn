cask "rio" do
  version "0.1.7"
  sha256 "c7ee5fad89dc5e12575fa518fe8be8cd5a80517ba0a963400a5c625be37beada"

  url "https:github.comraphamorimrioreleasesdownloadv#{version}Rio-v#{version}.dmg"
  name "Rio"
  desc "Hardware-accelerated GPU terminal emulator"
  homepage "https:github.comraphamorimrio"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "Rio.app"
  binary "Rio.appContentsMacOSrio"
  binary "Rio.appContentsResources72rio",
         target: "#{ENV.fetch("TERMINFO", "~.terminfo")}72rio"

  zap trash: "~LibrarySaved Application Statecom.raphaelamorim.rio.savedState"
end