cask "alex313031-thorium" do
  arch arm: "ARM64", intel: "X64"

  version "M124.0.6367.218"
  sha256 arm:   "0173afa7acfd7f0a875bf2d4b7a0aff113e3f5eee3c08961d7eb15eb7cfa42d5",
         intel: "1a6526f3259452f2d3e0f8163916b8cd2acb0cbf5d101dacc8ab6aad67b192f8"

  url "https:github.comAlex313031Thorium-MacOSreleasesdownload#{version}Thorium_MacOS_#{arch}.dmg",
      verified: "github.comAlex313031Thorium-MacOS"
  name "Thorium"
  desc "Web browser"
  homepage "https:thorium.rocks"

  livecheck do
    url :url
    regex(^(M?\d+(?:\.\d+)+)$i)
    strategy :github_latest
  end

  conflicts_with cask: "thorium"
  depends_on macos: ">= :high_sierra"

  app "Thorium.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}thorium.wrapper.sh"
  binary shimscript, target: "thorium"

  preflight do
    File.write shimscript, <<~EOS
      #!binbash
      exec '#{appdir}Thorium.appContentsMacOSThorium' "$@"
    EOS
  end

  zap trash: [
    "~LibraryApplication SupportThorium",
    "~LibraryCachesThorium",
    "~LibraryPreferencesorg.chromium.Thorium.plist",
    "~LibrarySaved Application Stateorg.chromium.Thorium.savedState",
  ]
end