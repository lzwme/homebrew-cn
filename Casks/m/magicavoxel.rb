cask "magicavoxel" do
  version "0.99.6.2,0.99.6"
  sha256 "4ee661e41da07f8c2b2b1c916bd1e18f7c5229900f30467eeea73ad74e861226"

  url "https:github.comephtracyephtracy.github.ioreleasesdownload#{version.csv.second || version.csv.first}MagicaVoxel-#{version.csv.first}-macos-10.15.zip",
      verified: "github.comephtracyephtracy.github.io"
  name "MagicaVoxel"
  desc "8-bit 3D voxel editor and interactive path tracing renderer"
  homepage "https:ephtracy.github.io"

  # Upstream doesn't provide a macOS file with every release, so we have to
  # check multiple GitHub releases instead of only the "latest" one.
  livecheck do
    url :url
    regex(MagicaVoxel[._-]v?(\d+(?:\.\d+)+)[._-]macos.*?\.zipi)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"]

        tag_version = release["tag_name"]&.[](^v?(\d+(?:\.\d+)+)$i, 1)
        next if tag_version.blank?

        release["assets"]&.map do |asset|
          match = asset["name"]&.match(regex)
          next if match.blank?

          (match[1] == tag_version) ? tag_version : "#{match[1]},#{tag_version}"
        end
      end.flatten
    end
  end

  suite staged_path, target: "MagicaVoxel"

  zap trash: [
    "~LibraryPreferencesEPH.MagicaVoxel.plist",
    "~LibrarySaved Application StateEPH.MagicaVoxel.savedState",
  ]
end