cask "desktoppr" do
  version "0.5,218"
  sha256 "1cfb67d7023bc6bc7b1e3c8ccf5c891a1bad22876df77f3fbc77d27877cc7b9d"

  url "https:github.comscriptingosxdesktopprreleasesdownloadv#{version.csv.first}desktoppr-#{version.tr(",", "-")}.pkg"
  name "desktoppr"
  desc "Command-line tool to set the desktop picture"
  homepage "https:github.comscriptingosxdesktoppr"

  livecheck do
    url :url
    regex(desktoppr[._-]v?(\d+(?:\.\d+)+)(?:[._-](\d+))?\.pkgi)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] || release["prerelease"]

        release["assets"]&.map do |asset|
          match = asset["name"]&.match(regex)
          next if match.blank?

          match[2].present? ? "#{match[1]},#{match[2]}" : match[1]
        end
      end.flatten
    end
  end

  pkg "desktoppr-#{version.tr(",", "-")}.pkg"

  uninstall pkgutil: "com.scriptingosx.desktoppr"

  # No zap stanza required
end