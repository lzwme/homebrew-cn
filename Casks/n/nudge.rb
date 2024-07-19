cask "nudge" do
  version "2.0.0.81706"
  sha256 "80b9dbdce5c1261d97728fb9d7a78a0a0c5030a951f3574bf84a1d995b8b936b"

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