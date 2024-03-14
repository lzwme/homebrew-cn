cask "obs-beta" do
  arch arm: "Apple", intel: "Intel"
  livecheck_folder = on_arch_conditional arm: "arm64", intel: "x86_64"

  version "30.1.0-rc1"
  sha256 arm:   "2a749d1308029a039e4cad6223076d90fa30a86c11e1e1271ac82ae7596624fe",
         intel: "15af4c79230a18f7e48cb1c2182b97b13b09420130cccf805814cbe77c009c41"

  url "https:cdn-fastly.obsproject.comdownloadsOBS-Studio-#{version}-macOS-#{arch}.dmg"
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