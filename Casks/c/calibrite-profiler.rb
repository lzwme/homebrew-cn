cask "calibrite-profiler" do
  version "3.0.1"
  sha256 "ddf3f77642a051715a0396e5a85fe07bf1476c8eea05b7843bcd33ea70f69420"

  url "https://ghfast.top/https://github.com/LUMESCA/calibrite-profiler-releases/releases/download/v#{version}/calibrite-PROFILER-#{version}.dmg",
      verified: "github.com/LUMESCA/calibrite-profiler-releases/"
  name "calibrite PROFILER"
  desc "Display calibration software for Calibrite, ColorChecker and X-Rite devices"
  homepage "https://calibrite.com/calibrite-profiler/"

  # Upstream sometimes marks a release as "pre-release" on GitHub but the
  # first-party download page links to the release as the latest stable
  # version. This checks the download page, which links to the latest dmg file
  # on GitHub without having to worry about latest/pre-release.
  livecheck do
    url "https://calibrite.com/us/software-downloads/"
    regex(/href=.*?calibrite-PROFILER[._-]v?(\d+(?:\.\d+)+)\.dmg/i)
  end

  auto_updates true

  app "calibrite PROFILER.app"

  zap trash: [
    "~/Library/Application Support/calibrite PROFILER",
    "~/Library/Application Support/calibrite-profiler",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.calibrite.profiler.sfl*",
    "~/Library/Caches/calibrite PROFILER",
    "~/Library/Logs/calibrite PROFILER",
    "~/Library/Logs/calibrite-profiler",
    "~/Library/Preferences/com.calibrite.profiler.plist",
    "~/Library/Saved Application State/com.calibrite.profiler.savedState",
  ]

  caveats do
    requires_rosetta
  end
end