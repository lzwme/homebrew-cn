cask "wljs-notebook" do
  arch arm: "arm64", intel: "x64"

  version "2.5.8"
  sha256 arm:   "94afff9069ab1329c3246103c26dfbad7ef1f668f4ebc84799c251796bc9c223",
         intel: "ed120cd7656342247bc634e1ae3f62f886d57254aed51f662b71c8061e18bb51"

  url "https:github.comJerryIwolfram-js-frontendreleasesdownload#{version.csv.second || version.csv.first}wljs-notebook-#{version.csv.first}-#{arch}.dmg"
  name "WLJS Notebook"
  desc "Javascript frontend for Wolfram Engine"
  homepage "https:github.comJerryIwolfram-js-frontend"

  # The upstream release tag can sometimes differ from the version in the
  # filename (e.g. 2.5.6FIX vs. 2.5.6), so we include the tag in the cask
  # `version` when this happens.
  livecheck do
    url :url
    regex(wljs[._-]notebook[._-]v?(\d+(?:\.\d+)+)i)
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