cask "librewolf" do
  arch arm: "arm64", intel: "x86_64"

  on_arm do
    version "132.0.2,1"
    sha256 "e2d6a2fc7a949c6bcf21d91e3c578284cf21881689b4b33fbb6b61e60d280fd6"
  end
  on_intel do
    version "132.0.2,1"
    sha256 "08b4243d08ec51c0ac34ef2406a9c59ee8f0674e47a5271779cc7fa631ab7e71"
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

  depends_on macos: ">= :catalina"

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