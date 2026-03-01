cask "conductor" do
  arch arm: "aarch64", intel: "x86_64"

  on_arm do
    version "0.36.9,01KJGZJ2G00D407MA2M3WVNWTT"
    sha256 "25ab76cdf1bfad7cf2c0414f19d9e1b2ccdb387af87011d71aa62383a77f33c1"
  end
  on_intel do
    version "0.36.9,01KJGZES77VZ9HSBC9HDNW4V4G"
    sha256 "e565bffdcc86be7e1067e0c8250aff65d666a10446b9542ed6e53e865c8a7d10"
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