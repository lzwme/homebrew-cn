cask "veusz" do
  arch arm: "arm", intel: "x86_64"

  version "4.0,4.0-fix"
  sha256 arm:   "7d80bd5e780d2101d904152a6b8337d7c2c7953d8aa24c3af76e98692549a6c7",
         intel: "092179e5d35b1e8ca663014d4d93de40ef2e4edae542c3cad98fccbda2ebf8e2"

  url "https:github.comveuszveuszreleasesdownloadveusz-#{version.csv.second || version.csv.first}veusz-#{version.csv.first}-AppleOSX-#{arch}.dmg",
      verified: "github.comveuszveusz"
  name "Veusz"
  desc "Scientific plotting application"
  homepage "https:veusz.github.io"

  livecheck do
    url :url
    regex(^veusz[._-]v?(\d+(?:\.\d+)+)(?:[._-].+)?\.dmg$i)
    strategy :github_latest do |json, regex|
      tag_version = json["tag_name"]&.[](^veusz[._-]v?(\d+(?:\.\d+)+(?:-fix)?)$i, 1)
      next if tag_version.blank?

      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        (match[1] == tag_version) ? tag_version : "#{match[1]},#{tag_version}"
      end
    end
  end

  app "Veusz.app"

  zap trash: "~LibraryPreferencesorg.veusz.veusz*.plist"
end