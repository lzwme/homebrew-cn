cask "calibrite-profiler" do
  version "3.0.0"
  sha256 "6fe9e1b5eef2787559d3f5c3fd10ad94516bc79f2042936040542049650ab4de"

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
  depends_on macos: ">= :high_sierra"

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