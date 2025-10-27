cask "gpgfrontend" do
  macos_version = nil

  version "2.1.10"

  on_arm do
    on_ventura :or_older do
      macos_version = 13

      sha256 "f611956a9b3d7b8a2dfda11a93ebe10ef64100e144890df5efcbd61a4aeb5a37"

      caveats do
        requires_rosetta
      end
    end
    on_sonoma do
      macos_version = 14

      sha256 "ae8af5945ac28ec214cb1eee8ae9e034de24f7e4519d5e6bce22bde17a983393"
    end
    on_sequoia :or_newer do
      macos_version = 15

      sha256 "28b05ae0b5e013e3de3d47006a1557d52557d09234313c586c3e4b2dd9ffa0a1"
    end
  end
  on_intel do
    macos_version = 13

    sha256 "f611956a9b3d7b8a2dfda11a93ebe10ef64100e144890df5efcbd61a4aeb5a37"
  end

  url "https://ghfast.top/https://github.com/saturneric/GpgFrontend/releases/download/v#{version}/GpgFrontend-#{version}-macos-#{macos_version}.dmg",
      verified: "github.com/saturneric/GpgFrontend/"
  name "GpgFrontend"
  desc "OpenPGP/GnuPG crypto, sign and key management tool"
  homepage "https://gpgfrontend.bktus.com/"

  depends_on formula: "gnupg"
  depends_on macos: ">= :ventura"

  app "GpgFrontend.app"

  zap trash: [
    "~/Library/Application Scripts/pub.gpgfrontend.gpgfrontend",
    "~/Library/Application Support/GpgFrontend",
    "~/Library/Containers/pub.gpgfrontend.gpgfrontend",
    "~/Library/Preferences/GpgFrontend",
    "~/Library/Preferences/GpgFrontend.plist",
    "~/Library/Preferences/pub.gpgfrontend.gpgfrontend.plist",
    "~/Library/Saved Application State/pub.gpgfrontend.gpgfrontend.savedState",
  ]
end