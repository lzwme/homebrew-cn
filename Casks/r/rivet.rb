cask "rivet" do
  version "1.11.0"
  sha256 "b38ab4489bd2990ef749574a06c1d6aced5be45a14b1c46d6f8ea6e2c4629248"

  url "https:github.comIroncladrivetreleasesdownloadapp-v#{version}Rivet.dmg", verified: "github.comIroncladrivet"
  name "Rivet"
  desc "Open-source visual AI programming environment"
  homepage "https:rivet.ironcladapp.com"

  livecheck do
    url :url
    regex(^app[._-]v?(\d+(?:\.\d+)+)$i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] || release["prerelease"]

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  depends_on macos: ">= :high_sierra"

  app "Rivet.app"

  zap trash: [
    "~LibraryApplication Supportcom.ironcladapp.rivet",
    "~LibraryCachescom.ironcladapp.rivet",
    "~LibraryWebKitcom.ironcladapp.rivet",
  ]
end