cask "librewolf" do
  arch arm: "arm64", intel: "x86_64"

  on_arm do
    version "122.0,1"
    sha256 "e7b3b981d59e281bb79d08e4230b71a0f8547f47bc26c4d7f02450ccb95dea59"
  end
  on_intel do
    version "122.0,1"
    sha256 "c6d84f15cc30ddf6d8fdd5d8c5674cf57e73a45ba01ff063d03246923c021b6d"
  end

  url "https:gitlab.comapiv4projects44042130packagesgenericlibrewolf#{version.csv.first}-#{version.csv.second}librewolf-#{version.csv.first}-#{version.csv.second}-macos-#{arch}-package.dmg",
      verified: "gitlab.comapiv4projects44042130packagesgenericlibrewolf"
  name "LibreWolf"
  desc "Web browser"
  homepage "https:librewolf.net"

  livecheck do
    url "https:gitlab.comapiv4projects44042130releases"
    regex(librewolf[._-]v?(\d+(?:\.\d+)+)[._-](\d+)[._-]macos[._-]#{arch}[._-]package\.dmgi)
    strategy :page_match do |page, regex|
      page.scan(regex).map do |match|
        "#{match[0]},#{match[1]}"
      end
    end
  end

  app "LibreWolf.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}librewolf.wrapper.sh"
  binary shimscript, target: "librewolf"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{appdir}LibreWolf.appContentsMacOSlibrewolf' "$@"
    EOS
  end

  zap trash: [
    "~.librewolf",
    "~LibraryApplication SupportLibreWolf",
    "~LibraryCachesLibreWolf Community",
    "~LibraryCachesLibreWolf",
    "~LibraryPreferencesio.gitlab.librewolf-community.librewolf.plist",
    "~LibrarySaved Application Stateio.gitlab.librewolf-community.librewolf.savedState",
  ]
end