cask "redcine-x-pro" do
  version "63.0.8"
  sha256 "c330414259ca30d417425f8bdfc56f644b75da99bf41de0b85c740d1f8e6e0a3"

  url "https://downloads.red.com/software/rcx/mac/release/#{version}/REDCINE-X_PRO_Build_#{version}.pkg"
  name "REDCINE-X PRO"
  desc "Transcode and manipulate REDCODE RAW footage"
  homepage "https://www.red.com/"

  livecheck do
    url "https://www.red.com/RedSuiteCentric/SCA-Kilimanjaro/services/Download.Service.ss?downloadIdentifier=redcine-x-pro-mac"
    regex(/Build[._-]v?(\d+(?:\.\d+)+)\.pkg/i)
    strategy :json do |json, regex|
      json["data"]&.map do |item|
        next if item["versionIsBeta"] == "T"

        match = item["versionUrl"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  pkg "REDCINE-X_PRO_Build_#{version}.pkg"

  uninstall pkgutil: [
              "com.red.pkg.REDCINE-XPRO",
              "com.red.pkg.SupportLibs",
            ],
            delete:  "/Applications/REDCINE-X Professional"

  zap trash: [
    "~/Library/Application Support/red",
    "~/Library/Logs/DiagnosticReports/RED PLAYER*",
    "~/Library/Saved Application State/com.red.RED-Tether.savedState",
  ]
end