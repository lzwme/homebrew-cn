cask "affinity-photo" do
  version "2.5.5,2636"
  sha256 "6e25109a7cbbd3b9c29b0e4279e0db8e2658668cbbdd3248dda06b2975d70760"

  url "https://affinity-update.s3.amazonaws.com/mac2/retail/Affinity%20Photo%20#{version.csv.first.major}%20Affinity%20Store%20#{version.csv.second}.zip",
      verified: "affinity-update.s3.amazonaws.com/"
  name "Affinity Photo #{version.csv.first.major}"
  desc "Professional image editing software"
  homepage "https://affinity.serif.com/en-us/photo/"

  livecheck do
    url "https://go.seriflabs.com/affinity-update-mac-retail-photo#{version.csv.first.major}"
    strategy :sparkle do |item|
      "#{item.short_version},#{item.version}"
    end
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Affinity Photo #{version.csv.first.major}.app"

  zap trash: [
    "~/Library/Application Support/Affinity Photo #{version.csv.first.major}",
    "~/Library/Caches/com.seriflabs.affinityphoto#{version.csv.first.major}",
    "~/Library/HTTPStorages/com.seriflabs.affinityphoto#{version.csv.first.major}",
    "~/Library/Preferences/com.seriflabs.affinityphoto#{version.csv.first.major}.plist",
    "~/Library/Saved Application State/com.seriflabs.affinityphoto#{version.csv.first.major}.savedState",
    "~/Library/WebKit/com.seriflabs.affinityphoto#{version.csv.first.major}",
  ]
end