cask "bonitastudiocommunity" do
  version "2023.2-u0"
  sha256 "f3afad3ef1735a188b687e3ab16490c82e2faf680ae1240490669aecbe7981a9"

  url "https://ghfast.top/https://github.com/bonitasoft/bonita-platform-releases/releases/download/#{version}/BonitaStudioCommunity-#{version}-x86_64.dmg",
      verified: "github.com/bonitasoft/bonita-platform-releases/"
  name "Bonita Studio Community Edition"
  desc "Business process automation and optimisation"
  homepage "https://www.bonitasoft.com/downloads"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2025-04-03", because: :discontinued

  installer script: {
    executable: "#{staged_path}/BonitaStudioCommunity-#{version}.app/Contents/MacOS/installbuilder.sh",
    args:       ["--mode", "unattended"],
  }

  uninstall quit:   "org.bonitasoft.studio.product",
            delete: "/Applications/BonitaStudioCommunity-#{version}.app"

  zap trash: [
    "/Library/Caches/org.bonitasoft.studio.product",
    "~/Library/Preferences/org.bonitasoft.studio.product.plist",
  ]

  caveats do
    requires_rosetta
  end
end