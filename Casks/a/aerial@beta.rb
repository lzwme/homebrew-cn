cask "aerial@beta" do
  version "3.5.2beta1"
  sha256 "a3e93220101065c617331162303ef79002cabb49bab3c158d5530e538eb391a0"

  url "https:github.comJohnCoatesAerialreleasesdownloadv#{version}Aerial.saver.zip",
      verified: "github.comJohnCoatesAerial"
  name "Aerial Screensaver"
  desc "Apple TV Aerial screensaver"
  homepage "https:aerialscreensaver.github.io"

  # Beta releases are marked as pre-release, so we have to use the
  # `GithubReleases` strategy to check all recent releases.
  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)*(?:[._-]?beta\d+)?)$i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"]

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  conflicts_with cask: "aerial"
  depends_on macos: ">= :sierra"

  screen_saver "Aerial.saver"

  zap trash: [
    "~LibraryApplication SupportAerial",
    "~LibraryCachesAerial",
    "~LibraryContainerscom.apple.ScreenSaver.*DataLibraryApplication SupportAerial",
    "~LibraryContainerscom.apple.ScreenSaver.*DataLibraryApplication SupportAerial",
    "~LibraryContainerscom.apple.ScreenSaver.*DataLibraryCachesAerial",
    "~LibraryContainerscom.apple.ScreenSaver.*DataLibraryCachesAerial",
    "~LibraryContainerscom.apple.ScreenSaver.*DataLibraryPreferencesByHostcom.JohnCoates.Aerial*.plist",
    "~LibraryPreferencesByHostcom.JohnCoates.Aerial*",
    "~LibraryScreen SaversAerial.saver",
  ]
end