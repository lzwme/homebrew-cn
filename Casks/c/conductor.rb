cask "conductor" do
  arch arm: "aarch64", intel: "x86_64"

  on_arm do
    version "0.50.0,01KQK18TRHXWKCKMA1XWM1HAGB"
    sha256 "ce100b20174b385b76c396f6910cd852a4db97466dda57b86d2482c6a85cc17f"
  end
  on_intel do
    version "0.50.0,01KQK18MZ9SP1R7Y7W35ZMHJJS"
    sha256 "16817cefbb524acf57fcdf3e2a431e377c9e211c5a6d42a9ab1c245d9294e3dc"
  end

  url "https://cdn.crabnebula.app/asset/#{version.csv.second}",
      verified: "cdn.crabnebula.app/asset/"
  name "Conductor"
  desc "Claude code parallelisation"
  homepage "https://conductor.build/"

  livecheck do
    url "https://cdn.crabnebula.app/update/melty/conductor/darwin-#{arch}/latest"
    regex(%r{/asset/([^?/]+)}i)
    strategy :json do |json, regex|
      asset_id = json["url"]&.[](regex, 1)
      version = json["version"]
      next if asset_id.blank? || version.blank?

      "#{version},#{asset_id}"
    end
  end

  auto_updates true
  depends_on :macos

  app "Conductor.app"

  zap trash: [
    "~/Library/Application Support/com.conductor.app",
    "~/Library/Caches/com.conductor.app",
    "~/Library/WebKit/com.conductor.app",
  ]
end