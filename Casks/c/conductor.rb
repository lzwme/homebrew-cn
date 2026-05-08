cask "conductor" do
  arch arm: "aarch64", intel: "x86_64"

  on_arm do
    version "0.51.3,01KR1RSJM754VN4JV8R75Q1B5X"
    sha256 "5cc14a7e44f15362e79cb6b9a9aacb6092311af0c9170294481e8b94544abd62"
  end
  on_intel do
    version "0.51.3,01KR1RTCQ4DY2XGFZVVE8BV0TK"
    sha256 "7940f6141ba2a0eefcfd278e084906ea3fac19fbbda9d93cf4d9af2906067392"
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