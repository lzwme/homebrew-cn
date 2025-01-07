cask "jasp" do
  arch arm: "arm64", intel: "x86_64"
  livecheck_folder = on_arch_conditional arm: "-apple-silicon"

  version "0.19.3.0"
  sha256 arm:   "d828e4650a45e48bcfd37837aed89f3feca847f478db4aa0dea951e49093ad3e",
         intel: "b5bb16e70421ae818c7ce11d606fc944805085b614f669169f3273f7bf79978e"

  url "https:github.comjasp-statsjasp-desktopreleasesdownloadv#{version.csv.first.major_minor_patch}JASP-#{version.csv.first}-macOS-#{arch}.dmg",
      verified: "github.comjasp-statsjasp-desktop"
  name "JASP"
  desc "Statistical analysis application"
  homepage "https:jasp-stats.org"

  livecheck do
    url "https:jasp-stats.orgthank-you-for-downloading-jasp-macos#{livecheck_folder}"
    regex(href=.*?JASP[._-]v?(\d+(?:\.\d+)+)[._-]macOS[._-]#{arch}(?:_(\d+))?\.dmgi)
    strategy :page_match do |page, regex|
      page.scan(regex).map do |match|
        match[1] ? "#{match[0]},#{match[1]}" : match[0]
      end
    end
  end

  depends_on macos: ">= :monterey"

  app "JASP.app"

  zap trash: [
    "~.JASP",
    "~LibraryApplication SupportJASP",
    "~LibraryCachesJASP",
    "~LibraryPreferencesorg.jasp-stats.JASP.plist",
    "~LibrarySaved Application Stateorg.jasp-stats.jasp.savedState",
  ]
end