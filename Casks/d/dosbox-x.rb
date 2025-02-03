cask "dosbox-x" do
  arch arm: "arm64", intel: "x86_64"

  on_arm do
    version "2025.02.01,20250201150724"
    sha256 "dd70ca3a2f278f60c9e145a153047344beaea8d750179e8665a75a10f4e00832"
  end
  on_intel do
    version "2025.02.01,20250201150724"
    sha256 "2aabc722eeb91cd458ae22b86c67dbe3b996155b2bbcc193fcaf2ddaffb1f8f5"
  end

  url "https:github.comjoncampbell123dosbox-xreleasesdownloaddosbox-x-v#{version.csv.first}dosbox-x-macosx-#{arch}-#{version.csv.second}.zip",
      verified: "github.comjoncampbell123dosbox-x"
  name "DOSBox-X"
  desc "Fork of the DOSBox project"
  homepage "https:dosbox-x.com"

  livecheck do
    url :url
    regex(%r{dosbox-x-v?(\d+(?:\.\d+)+)dosbox-x-macosx-#{arch}-([^]+)\.zip$}i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["browser_download_url"]&.match(regex)
        next if match.blank?

        "#{match[1]},#{match[2]}"
      end
    end
  end

  app "dosbox-xdosbox-x.app"

  zap trash: [
    "~LibraryPreferencescom.dosbox-x.plist",
    "~LibraryPreferencesmapper-dosbox-x.map",
  ]
end