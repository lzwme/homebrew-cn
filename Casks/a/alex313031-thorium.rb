cask "alex313031-thorium" do
  arch arm: "ARM", intel: "X64"

  version "M130.0.6723.174"
  sha256 arm:   "ba1c45a52962c5f7d9b293757b1ca7456171e240927c30dcdaf7fd48d2dc8c04",
         intel: "1c92f610b56bc893b4bb11d7513366b1f991e60918d8e5feba927b5f1da66cff"

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
  depends_on macos: ">= :catalina"

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