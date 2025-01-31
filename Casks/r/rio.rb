cask "rio" do
  version "0.2.5"
  sha256 "06947898722e7c7316466216016eab871b59bc1069e48c9fdb58476af7e7cc46"

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