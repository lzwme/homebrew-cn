cask "devilutionx" do
  version "1.5.4"
  sha256 "d95c726023b625af6e918700dd3d19b1d4888eb829cd2640ca97de96e4564cf8"

  url "https:github.comdiasurgicaldevilutionXreleasesdownload#{version}devilutionx-macos-universal.dmg"
  name "DevilutionX"
  desc "Diablo build for modern operating systems"
  homepage "https:github.comdiasurgicaldevilutionX"

  livecheck do
    url :url
    regex(%r{v?(\d+(?:\.\d+)+)devilutionx[._-]macos[._-]universal\.dmg$}i)
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

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :high_sierra"

  app "devilutionX.app"

  zap trash: [
        "~LibraryApplication SupportCrashReporterdevilutionX_*.plist",
        "~LibraryApplication Supportdiasurgicaldevilution",
        "~LibrarySaved Application Statecom.diasurgical.devilutionx.savedState",
      ],
      rmdir: "~LibraryApplication Supportdiasurgical"
end