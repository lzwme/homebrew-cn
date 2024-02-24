cask "obs-beta" do
  arch arm: "apple", intel: "intel"
  livecheck_folder = on_arch_conditional arm: "arm64", intel: "x86_64"

  version "30.1.0-beta3"
  sha256 arm:   "799a75e08f23a5e93005332bd2966e4531df7e8e34d6fceca16b55bbfa2d9135",
         intel: "fc83d5c6f0126fe7c930be3a403c7b13f5cfdd2b830245f620d0b2a78e7e99c5"

  url "https:cdn-fastly.obsproject.comdownloadsobs-studio-#{version}-macos-#{arch}.dmg"
  name "OBS"
  desc "Open-source software for live streaming and screen recording"
  homepage "https:obsproject.comforumlisttest-builds.20"

  livecheck do
    url "https:obsproject.comosx_updateupdates_#{livecheck_folder}_v2.xml"
    regex(obs[._-]studio[._-](\d+(?:[.-]\d+)+(?:(?:-beta)|(?:-rc))\d+)[._-]macosi)
    strategy :sparkle do |items, regex|
      items.find { |item| item.channel == "beta" }&.url&.scan(regex)&.flatten
    end
  end

  auto_updates true
  conflicts_with cask: "obs"
  depends_on macos: ">= :big_sur"

  app "OBS.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}obs.wrapper.sh"
  binary shimscript, target: "obs"

  preflight do
    File.write shimscript, <<~EOS
      #!binbash
      exec '#{appdir}OBS.appContentsMacOSOBS' "$@"
    EOS
  end

  uninstall delete: "LibraryCoreMediaIOPlug-InsDALobs-mac-virtualcam.plugin"

  zap trash: [
    "~LibraryApplication Supportobs-studio",
    "~LibraryHTTPStoragescom.obsproject.obs-studio",
    "~LibraryPreferencescom.obsproject.obs-studio.plist",
    "~LibrarySaved Application Statecom.obsproject.obs-studio.savedState",
  ]
end