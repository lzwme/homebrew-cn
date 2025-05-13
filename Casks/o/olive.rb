cask "olive" do
  arch arm: "arm64", intel: "x86_64"

  version "0.1.0,1e3cf53"
  sha256 "9ab6afc7ee9d7fb5083d1a49adea7dc5934bdbf6d635454cae4f8667fbd7c368"

  url "https:github.comolive-editorolivereleasesdownload#{version.csv.first}Olive-#{version.csv.second}-macOS.zip",
      verified: "github.comolive-editorolive"
  name "Olive"
  desc "Non-linear video editor"
  homepage "https:www.olivevideoeditor.org"

  # The upstream download page (https:www.olivevideoeditor.orgdownload) says
  # "Olive will return. Old downloads can be found on GitHub". This has to use
  # `GithubReleases` for now, as all releases are marked as pre-release.
  livecheck do
    url :url
    regex(%r{v?(\d+(?:\.\d+)+)Olive[._-](\h+)-macOS(?:[._-]#{arch})?\.(?:dmg|zip)}i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"]

        release["assets"]&.map do |asset|
          match = asset["browser_download_url"]&.match(regex)
          next if match.blank?

          "#{match[1]},#{match[2]}"
        end
      end.flatten
    end
  end

  depends_on macos: ">= :sierra"

  app "Olive.app"

  uninstall rmdir: "~LibraryApplication Supportolivevideoeditor.org{Olive,}"

  zap trash: [
    "~LibraryPreferencescom.*.Olive.plist",
    "~LibraryPreferencesolivevideoeditor.org",
  ]

  caveats do
    requires_rosetta
  end
end