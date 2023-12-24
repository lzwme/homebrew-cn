cask "codeedit" do
  version "0.0.3-alpha.37,7ba2f85"
  sha256 "5ddeec9ca96b467dc6846a2ca8476774490555598ac0360587c955b97794d628"

  url "https:github.comCodeEditAppCodeEditreleasesdownload#{version.csv.first}CodeEdit-#{version.csv.second}.dmg",
      verified: "github.comCodeEditAppCodeEdit"
  name "CodeEdit"
  desc "Code editor"
  homepage "https:www.codeedit.app"

  livecheck do
    url :url
    regex(%r{\D*?([^]+?)CodeEdit[._-]([a-f0-9]+)\.dmg$}i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["browser_download_url"]&.match(regex)
        next if match.blank?

        "#{match[1]},#{match[2]}"
      end
    end
  end

  depends_on macos: ">= :ventura"

  app "CodeEdit.app"

  zap trash: [
    "~LibraryApplication Scripts*.CodeEdit.OpenWithCodeEdit",
    "~LibraryApplication SupportCodeEdit",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocuments*.codeedit.sfl2",
    "~LibraryCaches*.CodeEdit",
    "~LibraryContainers*.CodeEdit.OpenWithCodeEdit",
    "~LibraryHTTPStorages*.CodeEdit",
    "~LibraryPreferences*.CodeEdit.plist",
    "~LibrarySaved Application State*.CodeEdit.savedState",
  ]
end