cask "alex313031-thorium" do
  arch arm: "ARM", intel: "X64"

  version "M121.0.6167.204"
  sha256 arm:   "64d294cbfbd7b5e6ef453784627f6c970e30d3881784c3f0e49cd8df324ad78e",
         intel: "adcfa9aa9cd93d49944852f5a79811beb1daf0b3d3ef3212d158569e8b737a86"

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