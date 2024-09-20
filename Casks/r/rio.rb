cask "rio" do
  version "0.1.15"
  sha256 "0daa5bade9fba457aa603fa528d86e89aa5e2bca10ab448adf099a20fbc9acc3"

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