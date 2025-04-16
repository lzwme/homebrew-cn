cask "ontime" do
  arch arm: "arm64", intel: "x64"

  version "3.14.5"
  sha256 arm:   "bcddef9cdbe9091a153c595f58a1462d85bdf968fda2613584a153addc603bca",
         intel: "395b994e33e3a31316ff29b77fc81ae4955ed91c1977117060be03e19a510311"

  url "https:github.comcpvalenteontimereleasesdownloadv#{version}ontime-macOS-#{arch}.dmg",
      verified: "github.comcpvalenteontime"
  name "Ontime"
  desc "Time keeping for live events"
  homepage "https:getontime.no"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "ontime.app"

  zap trash: [
    "~LibraryApplication Supportontime",
    "~LibraryPreferencesno.lightdev.ontime.plist",
    "~LibrarySaved Application Stateno.lightdev.ontime.savedState",
  ]
end