cask "rio" do
  version "0.2.10"
  sha256 "bd90e392ced54daec19d81fd4ba26f65c1edd207956fd5cb43d4de5b7caac8de"

  url "https:github.comraphamorimrioreleasesdownloadv#{version}rio.dmg"
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