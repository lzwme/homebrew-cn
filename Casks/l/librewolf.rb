cask "librewolf" do
  arch arm: "arm64", intel: "x86_64"

  on_arm do
    version "125.0.3,1"
    sha256 "6ec104359a7a6e3e6e310699831119f742979f254172c16b635e247d7f345a1a"
  end
  on_intel do
    version "125.0.3,1"
    sha256 "5e6d0d016a6decd47c28b6f42eafb350b47709dbe1f0f3523360986bae89f83f"
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