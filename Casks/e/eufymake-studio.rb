cask "eufymake-studio" do
  version "1.5.26.2,1.8.0"
  sha256 "beaa5760814cc7dc09818efebfbbb7c13113b5128a7db33afcd04fbc2c7c9b2d"

  url "https:github.comeufymakeeufyMake-PrusaSlicer-Releasereleasesdownloadv#{version.csv.first.major_minor_patch}eufyMake_Studio_V#{version.csv.first}_E#{version.csv.second}.dmg",
      verified: "github.comeufymakeeufyMake-PrusaSlicer-Release"
  name "eufyMake Studio"
  desc "Slicer for eufyMake 3D printers"
  homepage "https:www.eufymake.comeufymake-studio"

  livecheck do
    url :url
    regex(^eufyMake[._-]Studio[._-]v?(\d+(?:\.\d+)+)[._-]E(\d+(?:\.\d+)+)\.dmg$i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        "#{match[1]},#{match[2]}"
      end
    end
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :sierra"

  app "eufyMake Studio.app"

  zap trash: [
    "~LibraryApplication SupporteufyMake Studio Profile",
    "~LibraryCachescom.anker.pceufyMake",
    "~LibraryLogseufyMake",
    "~LibraryPreferencescom.anker.pceufyMake",
    "~LibraryWebKitcom.anker.pceufyMake",
  ]

  caveats do
    requires_rosetta
  end
end