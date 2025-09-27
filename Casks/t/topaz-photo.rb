cask "topaz-photo" do
  version "1.0.1"
  sha256 "c69d76e8a3ab45fb8c092813a7c7e88064c7d2979ae64de2affee674857a63d7"

  url "https://downloads.topazlabs.com/deploy/TopazPhoto/#{version}/TopazPhoto-#{version}.pkg"
  name "Topaz Photo"
  desc "AI image enhancer"
  homepage "https://www.topazlabs.com/topaz-photo"

  livecheck do
    url "https://topazlabs.com/d/photostudio/latest/mac/full"
    strategy :header_match
  end

  auto_updates true
  depends_on arch:  :arm64,
             macos: ">= :monterey"

  pkg "TopazPhoto-#{version}.pkg"

  uninstall pkgutil: "com.topazlabs.TopazPhoto",
            delete:  [
              "/Library/Application Support/Adobe/Plug-Ins/CC/TopazPhoto.plugin",
              "/Library/Application Support/Adobe/Plug-Ins/CC/TopazPhotoApply.plugin",
              "/Library/Application Support/Adobe/Plug-Ins/CC/TopazPhotoAutomate.plugin",
              "/Library/Application Support/Adobe/Plug-Ins/CC/TopazPhotoGather.plugin",
              "~/Library/Application Support/Adobe/Lightroom/External Editor Presets/TopazGigapixel.lrtemplate",
              "~/Library/Application Support/Adobe/Lightroom/Modules/Topaz Photo.lrplugin",
              "~/Library/Application Support/Affinity Photo 2/Plugins/TopazGigapixel.plugin",
              "~/Library/Application Support/Capture One/Plug-ins/TopazGigapixel.coplugin",
            ]

  zap trash: [
    "~/Library/Application Scripts/com.topazlabs.TopazPhotoplugin",
    "~/Library/Application Support/Topaz Labs LLC/Topaz Photo",
    "~/Library/Caches/Topaz Labs LLC/Topaz Photo",
    "~/Library/Containers/com.topazlabs.TopazPhotoplugin",
    "~/Library/Preferences/com.topazlabs.Topaz Photo.plist",
    "~/Library/Preferences/com.topazlabs.TopazPhoto.plist",
  ]
end