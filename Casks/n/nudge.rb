cask "nudge" do
  version "1.1.16.81564"
  sha256 "1b1e40bec582cd5832e345e11235f7ccea4d24fa54776692e07ffa0b17588b94"

  url "https:github.commacadminsnudgereleasesdownloadv#{version}Nudge-#{version}.pkg"
  name "Nudge"
  desc "Application for enforcing OS updates"
  homepage "https:github.commacadminsnudge"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  pkg "Nudge-#{version}.pkg"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}nudge.wrapper.sh"
  binary shimscript, target: "nudge"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec 'ApplicationsUtilitiesNudge.appContentsMacOSNudge' "$@"
    EOS
  end

  uninstall pkgutil: "com.github.macadmins.Nudge"

  zap trash: "~LibraryPreferencescom.github.macadmins.Nudge.plist"

  caveats <<~EOS
    Launchctl integration must be installed separately. For the download, see

      https:github.commacadminsnudgereleaseslatest
  EOS
end