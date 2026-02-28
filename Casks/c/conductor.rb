cask "conductor" do
  arch arm: "aarch64", intel: "x86_64"

  on_arm do
    version "0.36.7,01KJGB28JBHBY3ZZQQYQHCSAF1"
    sha256 "d14efaba89c7399704fd971887c4b81bfb6a859312c8840aeb0329b0e9efe65a"
  end
  on_intel do
    version "0.36.7,01KJGB4B76XSY194ASS8Q6MVFR"
    sha256 "f03abdefaad519f146a2c9308fd96219597256515504cf18ab52b5fcf432da42"
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