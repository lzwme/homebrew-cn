cask "alex313031-thorium" do
  arch arm: "ARM", intel: "X64"

  version "M119.0.6045.214"
  sha256 arm:   "ad8e7dd918aab3f77483ac5a690ab4c8f59bda7dbd046ddf876b2ae144004d16",
         intel: "afa8cf669d60ed600449b296981efdafca29a8703e7f99b1fc1729d1c3f98038"

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