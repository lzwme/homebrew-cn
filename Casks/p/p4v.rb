cask "p4v" do
  version "2025.1,2742992"
  sha256 "cba89c31500e707d7af9cac766588a584770971a01d0dd8a410d58d867b2534b"

  url "https:filehost.perforce.comperforcer#{version.major[-2..]}.#{version.minor}bin.macosx12uP4V.dmg"
  name "Perforce Helix Visual Client"
  name "P4Merge"
  name "P4V"
  desc "Visual client for Helix Core"
  homepage "https:www.perforce.comproductshelix-core-appshelix-visual-client-p4v"

  livecheck do
    url "https:help.perforce.comhelix-corerelease-notescurrentp4vnotes.txt"
    regex(%r{\(\s*v?(\d+(?:\.\d+)+)(\d+)\s*\)}i)
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