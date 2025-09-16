cask "windterm" do
  version "2.7.0"
  sha256 "8c1bc1363e01df5b06f45019da934752f5f29e8603cc843bd38e59bdff121bf7"

  url "https://ghfast.top/https://github.com/kingToolbox/WindTerm/releases/download/#{version.csv.second || version.csv.first}/WindTerm_#{version.csv.first}_Mac_Portable_x86_64.dmg"
  name "WindTerm"
  desc "SSH/SFTP/Shell/Telnet/Serial terminal"
  homepage "https://github.com/kingToolbox/WindTerm"

  # Upstream doesn't provide a macOS file with every release, so we have to
  # check multiple GitHub releases instead of only the "latest" one. They also
  # seem to regularly add patch versions to existing releases (e.g., adding
  # 2.6.1 files to the 2.6.0 release), so we optionally append the tag version
  # if it differs from the file version.
  livecheck do
    url :url
    regex(/WindTerm[._-]v?(\d+(?:\.\d+)+)(?:[._-]Mac|.*\.dmg)/i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] || release["prerelease"]

        tag_version = release["tag_name"]&.[](/^v?(\d+(?:\.\d+)+)$/i, 1)
        next if tag_version.blank?

        release["assets"]&.map do |asset|
          match = asset["name"]&.match(regex)
          next if match.blank?

          (match[1] == tag_version) ? tag_version : "#{match[1]},#{tag_version}"
        end
      end.flatten
    end
  end

  disable! date: "2026-09-01", because: :fails_gatekeeper_check

  auto_updates true

  app "WindTerm.app"

  zap trash: [
    "~/Library/Preferences/KingToolbox.WindTerm.plist",
    "~/Library/Saved Application State/KingToolbox.WindTerm.savedState",
  ]

  caveats do
    requires_rosetta
  end
end