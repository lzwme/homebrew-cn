cask "wljs-notebook" do
  arch arm: "arm64", intel: "x64"

  version "2.7.6"
  sha256 arm:   "6e8c9de3e7765f8ef0708d64dfdb0ffe1108dd294a719a242c7731198486ee9f",
         intel: "ebbb4af70c6f6e134d6dea68bef5ffbc4837243e2e40863c20a5195b187d8c31"

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