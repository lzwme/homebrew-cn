cask "proclaim" do
  arch arm: "-arm"

  version "4.18.0.0361"
  sha256 arm:   "99bbb77d1363badaf3934a4d744dd581461185457642867f47405aaaecfcb66f",
         intel: "b9db73bdb4d91723e507ff0443737f74aa60ea5f0a8771cde5c5dce427a3bff5"

  url "https://downloads.logoscdn.com/Proclaim/Installer/#{version}/Proclaim#{arch}.dmg",
      verified: "logoscdn.com/Proclaim/"
  name "Proclaim"
  desc "Church presentation software"
  homepage "https://proclaim.logos.com/"

  livecheck do
    url "https://clientservices.logos.com/update/v1/feed/proclaim-mac/stable.xml"
    strategy :xml do |xml|
      xml.get_elements("//logos:version")&.map { |item| item.text&.strip }
    end
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "Proclaim.app"

  zap trash: [
    "~/Library/Application Support/Proclaim",
    "~/Library/Preferences/com.logos.Proclaim.plist",
    "~/Library/Saved Application State/com.logos.Proclaim.savedState",
  ]
end