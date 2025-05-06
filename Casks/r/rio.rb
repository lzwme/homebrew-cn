cask "rio" do
  version "0.2.14"
  sha256 "a8d779df6d8f0390190fd0bfab84aff33314d28afe211332fc61ac442c50daf3"

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