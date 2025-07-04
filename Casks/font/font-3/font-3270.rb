cask "font-3270" do
  version "3.0.1,d916271"
  sha256 "623fb815b16d6c4940b5014a21c5474ef6cddb02c325d03f153341b676b4cffa"

  url "https://ghfast.top/https://github.com/rbanffy/3270font/releases/download/v#{version.csv.first}/3270_fonts_#{version.csv.second}.zip"
  name "IBM 3270"
  homepage "https://github.com/rbanffy/3270font"

  livecheck do
    url :url
    regex(%r{v?(\d+(?:\.\d+)+)/3270[._-]fonts[._-](\h+)\.zip}i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] || release["prerelease"]

        release["assets"]&.map do |asset|
          match = asset["browser_download_url"]&.match(regex)
          next if match.blank?

          "#{match[1]},#{match[2]}"
        end
      end.flatten
    end
  end

  no_autobump! because: :requires_manual_review

  font "3270-Regular.otf"
  font "3270Condensed-Regular.otf"
  font "3270SemiCondensed-Regular.otf"

  # No zap stanza required
end