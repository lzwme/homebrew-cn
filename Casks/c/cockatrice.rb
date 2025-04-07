cask "cockatrice" do
  on_monterey :or_older do
    version "2.9.0,2023-09-14,Rings.of.the.Wild"
    sha256 "4524c5b95928e88073d1f8be46d881288d6d0bf07d8e65185fbebc0491f29e08"

    url "https:github.comCockatriceCockatricereleasesdownload#{version.csv.second}-Release-#{version.csv.first}Cockatrice-#{version.csv.third}-#{version.csv.first}-macOS-11_Big_Sur.dmg",
        verified: "github.comCockatriceCockatrice"

    caveats do
      requires_rosetta
    end
  end
  on_ventura do
    version "2.10.2,2025-04-03,Omenpath,2.10.2"
    sha256 "c9e59ebe3eba15dd84d9a7bda73ab63866119aeec6d2740974e32c574fee25b1"

    url "https:github.comCockatriceCockatricereleasesdownload#{version.csv.second}-Release-#{version.csv.first}Cockatrice-#{version.csv.third}-#{version.csv.fourth}-macOS13_Intel.dmg",
        verified: "github.comCockatriceCockatrice"

    caveats do
      requires_rosetta
    end
  end
  on_sonoma do
    version "2.10.2,2025-04-03,Omenpath,2.10.2"
    sha256 "05e9cb269d7cd406d4368a1f71e4fc46fcb2f5ee4966f53c4f51060ab2fda33e"

    url "https:github.comCockatriceCockatricereleasesdownload#{version.csv.second}-Release-#{version.csv.first}Cockatrice-#{version.csv.third}-#{version.csv.fourth}-macOS14_Apple.dmg",
        verified: "github.comCockatriceCockatrice"
  end
  on_sequoia :or_newer do
    version "2.10.2,2025-04-03,Omenpath,2.10.2"
    sha256 "db074a25dc144aee8e665f7caeca7c8067cdf119e930dc4c98d9016c5e2034e2"

    url "https:github.comCockatriceCockatricereleasesdownload#{version.csv.second}-Release-#{version.csv.first}Cockatrice-#{version.csv.third}-#{version.csv.fourth}-macOS15_Apple.dmg",
        verified: "github.comCockatriceCockatrice"
  end

  name "Cockatrice"
  desc "Virtual tabletop for multiplayer card games"
  homepage "https:cockatrice.github.io"

  livecheck do
    url :url
    regex(%r{(\d+(?:-\d+)+)-Release-([^]+)Cockatrice-([^-]+)-(\d+(?:\.\d+)+(?:-beta)?)-macOS[.\w]*\.dmg$}i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["browser_download_url"]&.match(regex)
        next if match.blank?

        "#{match[2]},#{match[1]},#{match[3]},#{match[4]}"
      end
    end
  end

  depends_on macos: ">= :big_sur"

  app "cockatrice.app"
  app "oracle.app"
  app "servatrice.app"

  uninstall quit: [
    "com.cockatrice.cockatrice",
    "com.cockatrice.oracle",
    "com.cockatrice.servatrice",
  ]

  zap trash: [
    "~LibraryApplication SupportCockatrice",
    "~LibraryPreferencescom.cockatrice.Cockatrice.plist",
    "~LibraryPreferencescom.cockatrice.oracle.plist",
    "~LibraryPreferencesde.cockatrice.Cockatrice.plist",
    "~LibrarySaved Application Statecom.cockatrice.cockatrice.savedState",
    "~LibrarySaved Application Statecom.cockatrice.oracle.savedState",
  ]
end