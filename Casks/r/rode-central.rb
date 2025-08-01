cask "rode-central" do
  version "2.0.101"
  sha256 :no_check

  url "https://update.rode.com/central/RODE_Central_MACOS.zip"
  name "Rode Central"
  desc "RØDE companion app"
  homepage "https://rode.com/en/apps/rode-central"

  livecheck do
    url "https://update.rode.com/rode-devices-manifest.json"
    strategy :json do |json|
      json.dig("rode-central-manifest", "macos", "main-version", "update-version")
    end
  end

  depends_on macos: ">= :catalina"

  pkg "RØDE Central.pkg"

  preflight do
    staged_path.glob("RØDE Central*.pkg")&.first&.rename(staged_path/"RØDE Central.pkg")
  end

  uninstall pkgutil: "com.rodecentral.installer"

  zap trash: [
    "~/Library/Caches/com.rode.rodecentral",
    "~/Library/HTTPStorages/com.rode.rodecentral",
  ]
end