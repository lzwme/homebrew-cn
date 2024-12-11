cask "jasp" do
  arch arm: "arm64", intel: "x86_64"
  livecheck_folder = on_arch_conditional arm: "-apple-silicon"

  version "0.19.2.0"
  sha256 arm:   "4b6692c5b7d05d11f993ae5ee15eb7334e1ac80cf0f07483812740d60d17ce92",
         intel: "a0e2d44902baf3e8af0748c301b7aaa4cbac0d76ea4b18835c5ed756bcaac47a"

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