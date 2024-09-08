cask "devilutionx" do
  version "1.5.2"
  sha256 "a752d7ddb26fd1d6987fbbaf9d71f7d661c650c3054667aaa7ea5fb92b47407d"

  url "https:github.comdiasurgicaldevilutionXreleasesdownload#{version}devilutionx-macos-x86_64.dmg"
  name "DevilutionX"
  desc "Diablo build for modern operating systems"
  homepage "https:github.comdiasurgicaldevilutionX"

  livecheck do
    url :url
    regex(%r{v?(\d+(?:\.\d+)+)devilutionx[._-]macos[._-]x86_64\.dmg$}i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] || release["prerelease"]

        release["assets"]&.map do |asset|
          match = asset["browser_download_url"]&.match(regex)
          next if match.blank?

          match[1]
        end
      end.flatten
    end
  end

  depends_on macos: ">= :high_sierra"

  app "devilutionx.app"

  zap trash: [
        "~LibraryApplication SupportCrashReporterdevilutionX_*.plist",
        "~LibraryApplication Supportdiasurgicaldevilution",
      ],
      rmdir: "~LibraryApplication Supportdiasurgical"

  caveats do
    requires_rosetta
  end
end