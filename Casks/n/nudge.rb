cask "nudge" do
  version "2.0.10.81799"
  sha256 "9c88fb79b300e2a10683ded0c7d64ac00566a498aa480eaf95a14a48c9271870"

  url "https:github.commacadminsnudgereleasesdownloadv#{version}Nudge-#{version}.pkg"
  name "Nudge"
  desc "Application for enforcing OS updates"
  homepage "https:github.commacadminsnudge"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :monterey"

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