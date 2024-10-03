cask "keyguard" do
  version "1.6.0,20241002"
  sha256 "3631112e36eb33d5b9c7d2019bd418650c777d98b1fe2af1f9797e47364bf0ef"

  url "https:github.comAChepkeyguard-appreleasesdownloadr#{version.csv.second}Keyguard-#{version.csv.first}.dmg"
  name "Keyguard"
  desc "Client for the Bitwarden platform"
  homepage "https:github.comAChepkeyguard-app"

  livecheck do
    url :url
    regex(%r{r?(\d+(?:\.\d+)*)Keyguard[._-](\d+(?:\.\d+)+)\.dmg}i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["browser_download_url"]&.match(regex)
        next if match.blank?

        "#{match[2]},#{match[1]}"
      end
    end
  end

  depends_on macos: ">= :high_sierra"

  app "keyguard.app"

  zap trash: [
    "~LibraryApplication Supportkeyguard",
    "~LibrarySaved Application Statecom.artemchep.keyguard.savedState",
  ]

  caveats do
    requires_rosetta
  end
end