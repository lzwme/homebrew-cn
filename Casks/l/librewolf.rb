cask "librewolf" do
  arch arm: "arm64", intel: "x86_64"

  version "139.0,1"
  sha256 arm:   "f07b1c60a2e68c6db715fca325cc867d9ecd32cf4cc0665cf4ba2076923caf9b",
         intel: "caf4ecc0fe88e81084bf1e9e2869bc662ed3405806aa024ce7b1978c3a6c6381"

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