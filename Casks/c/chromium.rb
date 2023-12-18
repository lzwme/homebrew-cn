cask "chromium" do
  arch arm: "Mac_Arm", intel: "Mac"

  version :latest
  sha256 :no_check

  url "https:download-chromium.appspot.comdl#{arch}?type=snapshots",
      verified: "download-chromium.appspot.comdl"
  name "Chromium"
  desc "Free and open-source web browser"
  homepage "https:www.chromium.orgHome"

  conflicts_with cask: [
    "eloston-chromium",
    "freesmug-chromium",
  ]
  depends_on macos: ">= :catalina"

  app "chrome-macChromium.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}chromium.wrapper.sh"
  binary shimscript, target: "chromium"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{appdir}Chromium.appContentsMacOSChromium' "$@"
    EOS
  end

  zap trash: [
    "~LibraryApplication SupportChromium",
    "~LibraryCachesChromium",
    "~LibraryPreferencesorg.chromium.Chromium.plist",
    "~LibrarySaved Application Stateorg.chromium.Chromium.savedState",
  ]
end