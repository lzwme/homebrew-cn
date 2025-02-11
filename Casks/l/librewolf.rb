cask "librewolf" do
  arch arm: "arm64", intel: "x86_64"

  version "135.0-1"
  sha256 arm:   "f86cb5e913f0b4b4dabe4563aaf5724c31be4771d5d93066f14f3da117f18b06",
         intel: "dcf50b58d91eb98b74a1d586a009510397adb707a6f8db27493bba264071e2a8"

  url "https:gitlab.comapiv4projects44042130packagesgenericlibrewolf#{version}librewolf-#{version}-macos-#{arch}-package.dmg",
      verified: "gitlab.comapiv4projects44042130packagesgenericlibrewolf"
  name "LibreWolf"
  desc "Web browser"
  homepage "https:librewolf.net"

  livecheck do
    url "https:gitlab.comlibrewolf-communitybrowserbsys6.git"
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