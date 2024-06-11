cask "rio" do
  version "0.1.0"
  sha256 "f98d735dcd157f49fa6211408b78837935922aaa4a3ebe418b71c775858d73b3"

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