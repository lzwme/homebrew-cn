cask "rio" do
  version "0.2.17"
  sha256 "b0c104f0a7a6015fd3b9edf174495bf33d9df6ff8ed69f8df2c1b3e4f584e30c"

  url "https:github.comraphamorimrioreleasesdownloadv#{version}rio.dmg"
  name "Rio"
  desc "Hardware-accelerated GPU terminal emulator"
  homepage "https:github.comraphamorimrio"

  livecheck do
    url :url
    strategy :github_latest
  end

  conflicts_with formula: "rio"
  depends_on macos: ">= :catalina"

  app "rio.app"
  binary "rio.appContentsMacOSrio"
  binary "rio.appContentsResources72rio",
         target: "#{ENV.fetch("TERMINFO", "~.terminfo")}72rio"

  zap trash: "~LibrarySaved Application Statecom.raphaelamorim.rio.savedState"
end