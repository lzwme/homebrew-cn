cask "librewolf" do
  arch arm: "arm64", intel: "x86_64"

  version "140.0.2,1"
  sha256 arm:   "991765476e1f6194036dcbb55f1a2e537e7125819b28f8a6fa8d1b89b53ba956",
         intel: "86add2a38023fefa7c9e08660f89a4dc3a440918a1f1c4ed26aaaa066460de08"

  url "https:gitlab.comapiv4projects44042130packagesgenericlibrewolf#{version.tr(",", "-")}librewolf-#{version.tr(",", "-")}-macos-#{arch}-package.dmg",
      verified: "gitlab.comapiv4projects44042130packagesgenericlibrewolf"
  name "LibreWolf"
  desc "Web browser"
  homepage "https:librewolf.net"

  livecheck do
    url "https:gitlab.comlibrewolf-communitybrowserbsys6.git"
    regex(^v?(\d+(?:[.-]\d+)+)$i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("-", ",") }
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