cask "rio" do
  version "0.1.10"
  sha256 "3e5c3cce0cf1732dfbf63b1ebf27a08453e1ca822c94c5cc5116329a1d2484a5"

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