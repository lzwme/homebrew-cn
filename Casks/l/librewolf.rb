cask "librewolf" do
  arch arm: "arm64", intel: "x86_64"

  version "138.0.1,1"
  sha256 arm:   "dd59b7ee40c65b9e01958c62cbd0a0c0d443bd66d031f4e3b740366be38cb4b9",
         intel: "c1fd4e3a915cf46e35edd41d3567faf53061d24f599181b35a62ef79046116e1"

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