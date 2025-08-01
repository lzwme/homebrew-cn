cask "openbci" do
  version "6.0.0,beta.1"
  sha256 "4170c88adef9c5aba80e7b43155716729b871db0058f8f22374f828b2a7ddfde"

  url "https://ghfast.top/https://github.com/OpenBCI/OpenBCI_GUI/releases/download/v#{version.csv.first}-#{version.csv.second}/openbcigui_v#{version.csv.first}-#{version.csv.second}_macosx.dmg",
      verified: "github.com/OpenBCI/OpenBCI_GUI/"
  name "OpenBCI"
  desc "Connect to OpenBCI hardware, visualise and stream physiological data"
  homepage "https://openbci.com/"

  livecheck do
    url :url
    regex(/^openbcigui[._-]v?(\d+(?:\.\d+)+)[._-](.+)[._-]macosx\.dmg$/i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        "#{match[1]},#{match[2]}"
      end
    end
  end

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :mojave"

  app "OpenBCI_GUI.app"

  zap trash: "~/Documents/OpenBCI_GUI"

  caveats do
    requires_rosetta
  end
end