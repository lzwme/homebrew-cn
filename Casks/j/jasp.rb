cask "jasp" do
  arch arm: "arm64", intel: "x86_64"
  livecheck_folder = on_arch_conditional arm: "-apple-silicon"

  version "0.19.2.0"
  sha256 arm:   "f5c463d4733b24b1d94ef77e4d3a63ff91a63b293e1a05518d96246cf17913cd",
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