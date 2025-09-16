cask "vcam" do
  version "5.0.2"
  sha256 "f2366cd29c86413cd20015ba34e27dfce6810696be0f3541c0a625b6418829a2"

  url "https://installers.vcam.ai/VCam_#{version}.pkg"
  name "VCam"
  desc "Webcam background tool"
  homepage "https://vcam.ai/"

  livecheck do
    url "https://go.vcam.ai/download-mac"
    strategy :header_match
  end

  pkg "VCam_#{version}.pkg"

  postflight do
    # Description: Ensure console variant of postinstall is non-interactive.
    # This is because `open /Applications/VCam/VCam.app` is called from the
    # postinstall script of the package and we don't want any user intervention there.
    retries ||= 3
    ohai "The VCam package postinstall script launches the VCam app" if retries >= 3
    ohai "Attempting to close VCam.app to avoid unwanted user intervention" if retries >= 3
    return unless system_command "/usr/bin/pkill", args: ["-f", "/Applications/VCam/VCam.app"]
  rescue RuntimeError
    sleep 1
    retry unless (retries -= 1).zero?
    opoo "Unable to forcibly close VCam.app"
  end

  uninstall quit:    "ai.vcam.desktop",
            pkgutil: [
              "camera-helper",
              "electron-app",
              "vcam.ai-uninstall",
            ],
            delete:  "/Applications/VCam"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/ai.vcam.desktop.sfl*",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.splitmedialabs.camerahelper.sfl*",
    "~/Library/Application Support/VCam.ai",
    "~/Library/Preferences/ai.vcam.desktop.plist",
    "~/Library/Saved Application State/ai.vcam.desktop.savedState",
  ]
end