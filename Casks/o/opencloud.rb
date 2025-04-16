cask "opencloud" do
  arch arm: "arm64", intel: "x86_64"

  version "1.0.0-rc.3"
  sha256 arm:   "d4706f83df677267218978acf434eb359f7a775552f27b54cf51e8f7b3e0a253",
         intel: "ce65d35cd860e5ae2412d589f3f78060b3a0bef383bb9fad0da7866b14691ebc"

  url "https:github.comopencloud-eudesktopreleasesdownloadv#{version}OpenCloud_Desktop-v#{version}-macos-clang-#{arch}.pkg"
  name "OpenCloud Desktop"
  desc "Desktop syncing client for OpenCloud"
  homepage "https:github.comopencloud-eudesktop"

  # TODO: Update this to use the `GithubLatest` strategy (without a regex or
  # `strategy` block) when a stable version becomes available.
  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+.+)$i)
    strategy :github_releases do |json, regex|
      json.filter_map do |release|
        next if release["draft"]

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  pkg "OpenCloud_Desktop-v#{version}-macos-clang-#{arch}.pkg"

  uninstall pkgutil: [
    "eu.opencloud.client",
    "eu.opencloud.desktop",
    "eu.opencloud.finderPlugin",
  ]

  zap trash: [
    "~LibraryApplication Scriptseu.opencloud.desktopclient.FinderSyncExt",
    "~LibraryApplication SupportOpenCloud",
    "~LibraryCacheseu.opencloud.desktopclient",
    "~LibraryContainerseu.opencloud.desktopclient.FinderSyncExt",
    "~LibraryGroup Containers9B5WD74GWJ.eu.opencloud.desktopclient",
    "~LibraryPreferenceseu.opencloud.desktopclient.plist",
    "~LibraryPreferencesOpenCloud",
  ]
end