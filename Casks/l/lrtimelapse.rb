cask "lrtimelapse" do
  version "7.4.0"
  sha256 "0010e34f6a39b791faa13783b7366718f53c73c76ff130e8dc9828d3ffeee0b1"

  url "https://lrtimelapse.com/files/lrtimelapse-#{version.major}-mac/?version=#{version}"
  name "LRTimelapse"
  desc "Time lapse editing, keyframing, grading and rendering"
  homepage "https://lrtimelapse.com/"

  livecheck do
    url "https://lrtimelapse.com/download/"
    regex(/LRTimelapse[._-]?v?(\d+(?:\.\d+)+)[._-]mac\.dmg/i)
  end

  pkg "LRTimelapse #{version} Installer.pkg"

  uninstall script:  {
              executable: "/usr/local/LRTimelapse/uninstall.sh",
              input:      "\n",
              sudo:       true,
            },
            pkgutil: [
              "com.lrtimelapse.LRAddons",
              "com.lrtimelapse.LRTimelapse#{version.major}",
              "com.lrttimelapse.LRTTools",
            ]

  zap trash: "~/Library/Application Support/LRTimelapse"

  caveats do
    files_in_usr_local
  end
end