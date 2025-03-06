cask "librewolf" do
  arch arm: "arm64", intel: "x86_64"

  version "136.0-1"
  sha256 arm:   "ca97d0772a8d04c0171d508bf1a0d13e441d9574f75aa44423130aa96cc73af9",
         intel: "87fbb8cc48718a48032deab53d2fa0e8fae72388e67b34e753e7bcc2f5870b6a"

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