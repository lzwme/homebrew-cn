cask "devilutionx" do
  version "1.5.2"
  sha256 "a752d7ddb26fd1d6987fbbaf9d71f7d661c650c3054667aaa7ea5fb92b47407d"

  url "https:github.comdiasurgicaldevilutionXreleasesdownload#{version}devilutionx-macos-x86_64.dmg"
  name "DevilutionX"
  desc "Diablo build for modern operating systems"
  homepage "https:github.comdiasurgicaldevilutionX"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "devilutionx.app"

  zap trash: [
        "~LibraryApplication SupportCrashReporterdevilutionX_*.plist",
        "~LibraryApplication Supportdiasurgicaldevilution",
      ],
      rmdir: "~LibraryApplication Supportdiasurgical"
end