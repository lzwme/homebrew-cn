cask "wljs-notebook" do
  arch arm: "arm64", intel: "x64"

  version "2.7.1"
  sha256 arm:   "d307fdac8499324399e6bbb9726a3f5b320c4eff26343f78283e555b2fc05088",
         intel: "45fc395943fb2367284eda9f2b9a95245f717612cc94c2a9af51155377452a24"

  url "https:github.comJerryIwolfram-js-frontendreleasesdownloadv#{version.csv.second || version.csv.first}wljs-notebook-#{version.csv.first}-#{arch}-macos.dmg",
      verified: "github.comJerryIwolfram-js-frontend"
  name "WLJS Notebook"
  desc "Javascript frontend for Wolfram Engine"
  homepage "https:jerryi.github.iowljs-docs"

  # The upstream release tag can sometimes differ from the version in the
  # filename (e.g. 2.5.6FIX vs. 2.5.6), so we include the tag in the cask
  # `version` when this happens.
  livecheck do
    url :url
    regex(wljs[._-]notebook[._-]v?(\d+(?:\.\d+)+)[._-]#{arch}(?:[._-]macos)?\.dmgi)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] || release["prerelease"]

        tag = release["tag_name"]
        tag_version = tag[^v?(\d+(?:\.\d+)+.*)$i, 1]
        next if tag_version.blank?

        release["assets"]&.map do |asset|
          match = asset["name"]&.match(regex)
          next if match.blank?

          (match[1] == tag_version) ? tag_version : "#{match[1]},#{tag}"
        end
      end.flatten
    end
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "WLJS Notebook.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentswljs-notebook.sfl*",
    "~LibraryApplication Supportwljs-notebook",
    "~LibraryPreferenceswljs-notebook.plist",
    "~LibrarySaved Application Statewljs-notebook.savedState",
  ]
end