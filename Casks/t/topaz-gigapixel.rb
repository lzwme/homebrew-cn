cask "topaz-gigapixel" do
  version "1.0.2"
  sha256 "3e47a066460ed89636ede6d5ac659c3b00fdc92eb315d5044c03f34e1bf60af1"

  url "https://downloads.topazlabs.com/deploy/TopazGigapixel/#{version}/TopazGigapixel-#{version}.pkg"
  name "Topaz Gigapixel"
  desc "AI image upscaler"
  homepage "https://www.topazlabs.com/topaz-gigapixel"

  livecheck do
    url "https://topazlabs.com/d/gigapixelstudio/latest/mac/full"
    strategy :header_match
  end

  auto_updates true
  depends_on arch:  :arm64,
             macos: ">= :monterey"

  pkg "TopazGigapixel-#{version}.pkg"

  uninstall pkgutil: "com.topazlabs.TopazGigapixel",
            delete:  [
              "/Library/Application Support/Adobe/Plug-Ins/CC/TopazGigapixel.plugin",
              "/Library/Application Support/Adobe/Plug-Ins/CC/TopazGigapixelApply.plugin",
              "/Library/Application Support/Adobe/Plug-Ins/CC/TopazGigapixelAutomate.plugin",
              "/Library/Application Support/Adobe/Plug-Ins/CC/TopazGigapixelGather.plugin",
              "~/Library/Application Support/Adobe/Lightroom/External Editor Presets/TopazGigapixel.lrtemplate",
              "~/Library/Application Support/Affinity Photo 2/Plugins/TopazGigapixel.plugin",
              "~/Library/Application Support/Capture One/Plug-ins/TopazGigapixel.coplugin",
            ]

  zap trash: [
    "~/Library/Application Support/Topaz Labs LLC/Topaz Gigapixel",
    "~/Library/Cache/Topaz Labs LLC/Topaz Gigapixel",
    "~/Library/Preferences/com.topazlabs.Topaz Gigapixel.plist",
    "~/Library/Preferences/com.topazlabs.TopazGigapixel.plist",
  ]
end