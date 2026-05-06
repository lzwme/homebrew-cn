cask "conductor" do
  arch arm: "aarch64", intel: "x86_64"

  on_arm do
    version "0.51.0,01KQX735MD277Y8KNDGK5G819H"
    sha256 "286e1ed64f0965d5e5183a7ef1adf3c2bede8ca288aecd50d0a2e6237f43b006"
  end
  on_intel do
    version "0.51.0,01KQX73K5RTK0HXDW7FX5N42VM"
    sha256 "1de2ca96ecacb019620f751ffa46fe007fa1dcbf67c1c87d2c9d2382b5b3ab6b"
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