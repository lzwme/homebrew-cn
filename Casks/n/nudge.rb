cask "nudge" do
  version "2.0.5.81760"
  sha256 "bae5d0c89f9133abfc3d892194058e01b888169a8f523359972b3c90c72c8def"

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