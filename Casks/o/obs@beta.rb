cask "obs@beta" do
  arch arm: "apple", intel: "intel"
  livecheck_folder = on_arch_conditional arm: "arm64", intel: "x86_64"

  version "31.1.0-beta2"
  sha256 arm:   "94fc30ea6eec525a813235eef3687cfcd8ca4e498a1fc187cee3d9c66a23322e",
         intel: "b2f7dc8fcdc01e22c656ba1909aa2d1165c0ff55d477353d14f1d481b4999d2f"

  url "https:cdn-fastly.obsproject.comdownloadsobs-studio-#{version}-macos-#{arch}.dmg"
  name "OBS"
  desc "Open-source software for live streaming and screen recording"
  homepage "https:obsproject.comforumlisttest-builds.20"

  livecheck do
    url "https:obsproject.comosx_updateupdates_#{livecheck_folder}_v2.xml"
    regex(obs[._-]studio[._-](\d+(?:[.-]\d+)+(?:(?:-beta)|(?:-rc))\d+)[._-]macosi)
    strategy :sparkle do |items, regex|
      items.map do |item|
        next if item.channel != "beta"

        item.url&.[](regex, 1)
      end
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