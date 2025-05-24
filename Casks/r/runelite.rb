cask "runelite" do
  arch arm: "aarch64", intel: "x64"

  version "2.7.5"
  sha256 arm:   "1dc56ac2d5ebf131047e62a797b8dd60647eb1f8ce50fd4c3bc3e4a43b138e3e",
         intel: "2e2fac124eb7f75749b6bcc63588e2ffd95406bddf76d72577ddeb1ebafb11ee"

  url "https:github.comrunelitelauncherreleasesdownload#{version}RuneLite-#{arch}.dmg",
      verified: "github.comrunelitelauncher"
  name "RuneLite"
  desc "Client for Old School RuneScape"
  homepage "https:runelite.net"

  livecheck do
    url :homepage
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)RuneLite[._-]#{arch}\.dmg}i)
  end

  app "RuneLite.app"

  zap trash: [
    "~.runelite",
    "~jagex_cl_oldschool_LIVE.dat",
    "~jagexcacheoldschool",
    "~random.dat",
  ]
end