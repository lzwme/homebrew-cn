cask "imaging-edge-webcam" do
  version "120_2403a,xB4KucKqdT"
  sha256 "70f4558ad5ec37127ed58b755bde1acb268edf88b5eba61a17388641215da9fd"

  url "https:di.update.sony.netNEX#{version.csv.second}IEW#{version.csv.first}.dmg",
      verified: "di.update.sony.netNEX"
  name "Sony Imaging Edge Webcam"
  desc "Use your Sony camera as a high-quality webcam"
  homepage "https:support.d-imaging.sony.co.jpappwebcamen"

  livecheck do
    url "https:support.d-imaging.sony.co.jpdisoft_DLwebcammac?fm=us"
    regex(%r{([a-z0-9]+)IEW(\d+_\d+[a-z]?)\.dmg}i)
    strategy :header_match do |headers, regex|
      match = headers["location"]&.scan(regex)&.flatten
      next if match.blank?

      "#{match[1]},#{match[0]}"
    end
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :ventura"

  pkg "IEW_INST.pkg"

  # The pkg installs a system extension which cannot be uninstalled automatically
  # at this time. Once this limitation is removed, the extension can be uninstalled
  # using: `systemextensionsctl uninstall "com.sony.imagingedge.iew.CameraExt"`.
  # Ref: https:github.comHomebrewhomebrew-caskpull198845#discussion_r1922162342
  uninstall quit:    "com.sony.imagingedge.iew",
            pkgutil: "com.sony.Webcam"

  # No zap stanza required
end