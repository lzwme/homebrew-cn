cask "dosbox-x" do
  arch arm: "arm64", intel: "x86_64"

  on_arm do
    version "2024.10.01,20241002061636"
    sha256 "31b66b372978825d59d0923fb379794ac8abc7fb4aa2fe2f320817fe921f154e"
  end
  on_intel do
    version "2024.10.01,20241002061636"
    sha256 "cdf55635cff61a45bf60f03f0133ce54ae7f5d8b86fa4b47ce8e1a713ea001f6"
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