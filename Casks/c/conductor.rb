cask "conductor" do
  arch arm: "aarch64", intel: "x86_64"

  on_arm do
    version "0.36.3,01KJ6AJS4ZEDHJ1X09XWG1K64D"
    sha256 "432ac2539d1945b5cc4e6908a2d1e41f306449c1fcf77290f62b20931ddeedf3"
  end
  on_intel do
    version "0.36.3,01KJ6A8C7HQ1PWAW3TETC7QBHA"
    sha256 "67763e9e00050286f3afff6f9ec08bf0c14be94003877e044f017735cfbcbb1a"
  end

  url "https://cdn.crabnebula.app/asset/#{version.csv.second}",
      verified: "cdn.crabnebula.app/asset/"
  name "Conductor"
  desc "Claude code parallelisation"
  homepage "https://conductor.build/"

  livecheck do
    url "https://cdn.crabnebula.app/update/melty/conductor/darwin-#{arch}/latest"
    regex(%r{cdn.crabnebula.app/asset/(.+)}i)
    strategy :json do |json, regex|
      asset_id = json["url"]&.[](regex, 1)
      version = json["version"]
      next if asset_id.blank? || version.blank?

      "#{version},#{asset_id}"
    end
  end

  auto_updates true

  app "Conductor.app"

  zap trash: [
    "~/Library/Application Support/com.conductor.app",
    "~/Library/Caches/com.conductor.app",
    "~/Library/WebKit/com.conductor.app",
  ]
end