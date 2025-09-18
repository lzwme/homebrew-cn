cask "pcsx2" do
  version "2.4.0"
  sha256 "9c4c4abb95b0055c5403c3f70d9ed25659f9cce457711de533f8168c5c60015f"

  url "https://ghfast.top/https://github.com/PCSX2/pcsx2/releases/download/v#{version}/pcsx2-v#{version}-macos-Qt.tar.xz",
      verified: "github.com/PCSX2/pcsx2/"
  name "PCSX2"
  desc "Playstation 2 Emulator"
  homepage "https://pcsx2.net/"

  livecheck do
    url "https://api.pcsx2.net/v1/stableReleases?pageSize=1"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :json do |json, regex|
      json["data"]&.map do |release|
        next unless release.dig("assets", "MacOS")

        release["version"]&.[](regex, 1)
      end
    end
  end

  depends_on macos: ">= :big_sur"

  app "PCSX2-v#{version}.app", target: "PCSX2.app"

  zap trash: [
    "~/Library/Application Support/PCSX2",
    "~/Library/Preferences/net.pcsx2.pcsx2.plist",
    "~/Library/Saved Application State/net.pcsx2.pcsx2.savedState",
  ]

  caveats do
    requires_rosetta
  end
end