cask "rio" do
  version "0.2.15"
  sha256 "b117c62872fe6a155a150ea193c1826e7667bd38e8c405454e9e20bde0237ab8"

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