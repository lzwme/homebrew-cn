cask "rio" do
  version "0.2.18"
  sha256 "5b39e6325598ed0b8b18e378205471b69259c5926e87c62fc969dfc3a754c236"

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