cask "conductor" do
  arch arm: "aarch64", intel: "x86_64"

  on_arm do
    version "0.51.2,01KQZR9RK6VDY84S6RBJNBH10S"
    sha256 "af00c896b87119cdcf7fe09559420558acf1ae3dcbc8858970edaa9c02cf1075"
  end
  on_intel do
    version "0.51.2,01KQZRA4X5Z3A17SARSNEGXAQF"
    sha256 "2e33b0b246b03f92f6dc6231e4d6bf465853039d86fbb46a27dc71eac10582b5"
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