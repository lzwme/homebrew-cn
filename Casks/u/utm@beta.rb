cask "utm@beta" do
  version "4.5.3"
  sha256 "ee1a564dee93be7368745b75ad2446a2e81e66e123bd27ae57305615f628e776"

  url "https:github.comutmappUTMreleasesdownloadv#{version}UTM.dmg",
      verified: "github.comutmappUTM"
  name "UTM"
  desc "Virtual machines UI using QEMU"
  homepage "https:mac.getutm.app"

  # This uses the `GithubReleases` strategy and includes releases marked as
  # "pre-release", so this will use both unstable and stable releases.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+.*)$i)
    strategy :github_releases do |json|
      json.map do |release|
        next if release["draft"]

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  conflicts_with cask: "utm"
  depends_on macos: ">= :big_sur"

  app "UTM.app"
  binary "#{appdir}UTM.appContentsMacOSutmctl"

  uninstall quit: "com.utmapp.UTM"

  zap trash: [
    "~LibraryApplication Scriptscom.utmapp.QEMUHelper",
    "~LibraryApplication Scriptscom.utmapp.UTM",
    "~LibraryContainerscom.utmapp.QEMUHelper",
    "~LibraryContainerscom.utmapp.UTM",
    "~LibraryGroup Containers*.com.utmapp.UTM",
    "~LibraryPreferencescom.utmapp.UTM.plist",
    "~LibrarySaved Application Statecom.utmapp.UTM.savedState",
  ]
end