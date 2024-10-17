cask "sonos" do
  version "81.1-58074,R3MV5bKh64"
  sha256 "9eac889a38810a321fcffc6c23b0481474b1480576e23bba5d01d026eac5f6d7"

  url "https://update-software.sonos.com/software/#{version.csv.second}/Sonos_#{version.csv.first}.dmg"
  name "Sonos S2"
  desc "Control your Sonos system"
  homepage "https://www.sonos.com/"

  livecheck do
    url "https://www.sonos.com/redir/controller_software_mac2"
    regex(%r{software/(\w+)/Sonos[._-]v?(\d+(?:.\d+)+)\.dmg}i)
    strategy :header_match do |headers, regex|
      headers["location"]&.scan(regex)&.map { |match| "#{match[1]},#{match[0]}" }
    end
  end

  auto_updates true
  depends_on macos: ">= :el_capitan"

  app "Sonos.app"

  zap trash: "~/Library/Application Support/SonosV2"

  caveats do
    requires_rosetta
  end
end