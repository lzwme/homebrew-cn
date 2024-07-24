cask "obs" do
  arch arm: "Apple", intel: "Intel"
  livecheck_folder = on_arch_conditional arm: "arm64", intel: "x86_64"

  version "30.2.2"
  sha256 arm:   "160f24804f8c70bd70d88ab0c9c8dcc4e88bc42c5c53e2705ced3216a434be96",
         intel: "0bea96aea2a5cb4fc1ab3b24ae3677ccf5542c10cd2d610264f4a39dd582c67b"

  url "https:cdn-fastly.obsproject.comdownloadsOBS-Studio-#{version}-macOS-#{arch}.dmg"
  name "OBS"
  desc "Open-source software for live streaming and screen recording"
  homepage "https:obsproject.com"

  livecheck do
    url "https:obsproject.comosx_updateupdates_#{livecheck_folder}_v2.xml"
    regex(obs[._-]studio[._-]v?(\d+(?:\.\d+)+)[._-]macos[._-]#{arch}\.dmgi)
    strategy :sparkle do |items, regex|
      items.find { |item| item.channel == "stable" }&.url&.scan(regex)&.flatten
    end
  end

  auto_updates true
  conflicts_with cask: "obs@beta"
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