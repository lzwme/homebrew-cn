cask "boop" do
  version "1.4.0"
  sha256 "8c4492baf6d5b1d26d157877f53d063259e615d784e8ab4d046d3ee67fb9b345"

  url "https://ghfast.top/https://github.com/IvanMathy/Boop/releases/download/#{version}/Boop.zip",
      verified: "github.com/IvanMathy/Boop/"
  name "Boop"
  desc "Scriptable scratchpad for developers"
  homepage "https://boop.okat.best/"

  livecheck do
    url "https://boop.okat.best/version.json"
    strategy :json do |json|
      json.dig("standalone", "version")
    end
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :mojave"

  app "Boop.app"

  zap trash: [
    "~/Library/Application Scripts/com.okatbest.boop",
    "~/Library/Containers/com.okatbest.boop",
  ]
end