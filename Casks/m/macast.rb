cask "macast" do
  version "0.7"
  sha256 "076500271e727f11f02eebb2731d2e6e80cf80d5f077fc1191293660312e2cfa"

  url "https:github.comxfangfangMacastreleasesdownloadv#{version}Macast-MacOS-v#{version}.dmg"
  name "Macast"
  desc "DLNA Media Renderer"
  homepage "https:github.comxfangfangMacast"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :mojave"

  app "Macast.app"

  zap trash: [
    "~LibraryApplication SupportMacast",
    "~LibraryPreferencescn.xfangfang.Macast.plist",
    "~LibrarySaved Application Statecn.xfangfang.Macast.savedState",
  ]

  caveats do
    requires_rosetta
  end
end