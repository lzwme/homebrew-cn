cask "obs-beta" do
  arch arm: "apple", intel: "intel"
  livecheck_folder = on_arch_conditional arm: "arm64", intel: "x86_64"

  version "30.0.0-rc2"
  sha256 arm:   "d8f59b7ea285ec68650931817c0813553ffa3092ba6d7e7b924d668a9373260e",
         intel: "09243679a3fbbf41b448624bfcf7417afc518d20a3fbcfe977ca6d47c5a51881"

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