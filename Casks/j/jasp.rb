cask "jasp" do
  arch arm: "arm64", intel: "x86_64"
  livecheck_folder = on_arch_conditional arm: "-apple-silicon"

  version "0.19.1.0"
  sha256 arm:   "810d47f9a995865b8f8c0dc38db79e92d449669a2bd7b71cbf85e9c68179e12e",
         intel: "ec00c4822928c57afc1c8c37658d4d8e29717bdc6a704a6dd7573352618bc78c"

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