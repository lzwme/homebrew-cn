cask "calibrite-profiler" do
  version "2.0.0"
  sha256 "8f391499e2d60fbd74728ec01372000665b87e0f49042e5f61c39069e0d2f41d"

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

  no_autobump! because: :requires_manual_review

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