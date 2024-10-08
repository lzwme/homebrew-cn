cask "p4v" do
  version "2024.3,2656785"
  sha256 "6d0c3a2eefcc40a5a47c1c1ee991eed0ef8911b54cfb65234572ece278c719ed"

  url "https:filehost.perforce.comperforcer#{version.major[-2..]}.#{version.minor}bin.macosx12uP4V.dmg"
  name "Perforce Helix Visual Client"
  name "P4Merge"
  name "P4V"
  desc "Visual client for Helix Core"
  homepage "https:www.perforce.comproductshelix-core-appshelix-visual-client-p4v"

  livecheck do
    url "https:www.perforce.comsupportsoftware-release-index"
    regex(%r{(?:Patch|Release) for[^<]+?Helix Visual Client[^<]+?v?(\d+(?:\.\d+)+)(\d+)}im)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| "#{match[0]},#{match[1]}" }
    end
  end

  app "p4v.app"
  app "p4admin.app"
  app "p4merge.app"
  binary "p4vc"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  p4_wrapper = "#{staged_path}p4.wrapper.sh"
  binary p4_wrapper, target: "p4v"
  binary p4_wrapper, target: "p4admin"
  binary p4_wrapper, target: "p4merge"

  preflight do
    File.write p4_wrapper, <<~EOS
      #!binbash
      set -euo pipefail
      COMMAND=$(basename "$0")
      if [[ "$COMMAND" == "p4merge" ]]; then
        exec "#{appdir}${COMMAND}.appContentsResourceslaunch${COMMAND}" "$@" 2> devnull
      else
        exec "#{appdir}${COMMAND}.appContentsMacOS${COMMAND}" "$@" 2> devnull
      fi
    EOS
  end

  zap trash: [
    "~LibraryPreferencescom.perforce.p4v",
    "~LibraryPreferencescom.perforce.p4v.plist",
    "~LibrarySaved Application Statecom.perforce.p4v.savedState",
  ]
end