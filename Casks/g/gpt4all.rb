cask "gpt4all" do
  version "3.9.0"
  sha256 "920e6fab3830a75fb54ef3e5b951caf86df832323d157d46c1c127bc5e123da6"

  url "https:github.comnomic-aigpt4allreleasesdownloadv#{version}gpt4all-installer-macos-v#{version}.dmg",
      verified: "github.comnomic-aigpt4all"
  name "GPT4All"
  desc "Run LLMs locally"
  homepage "https:www.nomic.aigpt4all"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :monterey"

  installer manual: "gpt4all-installer-darwin.app"

  uninstall script: "Applicationsgpt4allmaintenancetool.appContentsMacOSmaintenancetool",
            delete: "~LibraryApplication Supportnomic.aiGPT4All"

  zap trash: [
    "~LibraryApplication SupportGPT4All",
    "~LibraryPreferencescom.nomic-ai.gpt4all.plist",
    "~LibrarySaved Application Stategpt4all.savedState",
  ]
end