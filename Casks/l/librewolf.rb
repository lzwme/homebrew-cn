cask "librewolf" do
  arch arm: "arm64", intel: "x86_64"

  on_arm do
    version "127.0.1,1"
    sha256 "c0a7b7f69295ff1b4b1789f9a04563a8ed078e03d5af8e28769f1d0616fb513f"
  end
  on_intel do
    version "127.0.1,1"
    sha256 "9e00d989c762652797629ff0ed0f65e0d73d5761358a4099584dab5a142e806a"
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