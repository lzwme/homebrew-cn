cask "extraterm" do
  version "0.76.0"
  sha256 "830de38951be05d7f78ead7458dd3785a6cd0a08b9207d215a343faa53c8ce60"

  url "https:github.comsedwards2009extratermreleasesdownloadv#{version}ExtratermQt_#{version}.dmg",
      verified: "github.comsedwards2009extraterm"
  name "extraterm"
  desc "Swiss army chainsaw of terminal emulators"
  homepage "https:extraterm.org"

  # As of writing, upstream marks all releases on GitHub as "pre-release".
  # This should be updated to use the `GithubLatest` strategy ifwhen stable
  # versions become available.
  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)$i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        # This omits the usual `release["prerelease"]` early return condition,
        # as we need to work with pre-release versions for now.
        next if release["draft"]

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  app "ExtratermQt.app"

  zap trash: [
    "~LibraryApplication Supportextraterm",
    "~LibraryPreferencescom.electron.extraterm.helper.plist",
    "~LibraryPreferencescom.electron.extraterm.plist",
  ]
end