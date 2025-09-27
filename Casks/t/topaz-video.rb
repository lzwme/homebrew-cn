cask "topaz-video" do
  version "1.0.1"
  sha256 "11643bbe1df7aa89a0304157ea6700dcc6db1f233169ad1b068a549c8a82409e"

  url "https://downloads.topazlabs.com/deploy/TopazVideoStudio/#{version}/TopazVideo-#{version}.pkg"
  name "Topaz Video"
  desc "Video upscaler and quality enhancer"
  homepage "https://www.topazlabs.com/topaz-video"

  livecheck do
    url "https://topazlabs.com/d/videostudio/latest/mac/full"
    strategy :header_match
  end

  auto_updates true
  depends_on arch:  :arm64,
             macos: ">= :big_sur"

  pkg "TopazVideo-#{version}.pkg"

  # Unlike the previous version of this app (topaz-video-ai), the .pkg installer does not contain
  # supplementary packages to install the plugins. Additionally, the app does not contain the menu
  # options for the user to manually install the plugins post-installation. Until this is resolved
  # by the vendor, trigger the plugin installation scripts here so the end state is a ready-to-use
  # installation as per the previous version users are likely to be transitioning from.
  postflight do
    system "sudo", "bash", "#{appdir}/Topaz Video.app/Contents/Resources/ae_inst.sh"
    system "sudo", "bash", "#{appdir}/Topaz Video.app/Contents/Resources/ofx_inst.sh"
  end

  uninstall pkgutil: "com.topazlabs.VStudioPackage",
            delete:  [
              "/Applications/Adobe After Effects 2020/Plug-ins/Topaz Video AI Frame Interpolation.plugin",
              "/Applications/Adobe After Effects 2020/Plug-ins/Topaz Video AI.plugin",
              "/Applications/Adobe After Effects 2021/Plug-ins/Topaz Video AI Frame Interpolation.plugin",
              "/Applications/Adobe After Effects 2021/Plug-ins/Topaz Video AI.plugin",
              "/Applications/Adobe After Effects 2022/Plug-ins/Topaz Video AI Frame Interpolation.plugin",
              "/Applications/Adobe After Effects 2022/Plug-ins/Topaz Video AI.plugin",
              "/Applications/Adobe After Effects 2023/Plug-ins/Topaz Video AI Frame Interpolation.plugin",
              "/Applications/Adobe After Effects 2023/Plug-ins/Topaz Video AI.plugin",
              "/Applications/Adobe After Effects 2024/Plug-ins/Topaz Video AI Frame Interpolation.plugin",
              "/Applications/Adobe After Effects 2024/Plug-ins/Topaz Video AI.plugin",
              "/Applications/Adobe After Effects 2025/Plug-ins/Topaz Video AI Frame Interpolation.plugin",
              "/Applications/Adobe After Effects 2025/Plug-ins/Topaz Video AI.plugin",
              "/Library/OFX/Plugins/Topaz Video AI.ofx.bundle",
            ]

  zap trash: [
    "~/Library/Application Support/Topaz Labs LLC/Topaz Video",
    "~/Library/Caches/Topaz Labs LLC/Topaz Video",
    "~/Library/Preferences/com.topazlabs.Topaz Video.plist",
    "~/Library/Preferences/com.topazlabs.Topaz-Video.plist",
  ]
end