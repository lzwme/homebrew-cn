cask "fluffydisplay" do
  version "1.0,5"
  sha256 "7e54120d18443a19444213ba403604c27fb0d455195f54036872cca4f92820c6"

  url "https://ghfast.top/https://github.com/tml1024/FluffyDisplay/releases/download/#{version.csv.first}(#{version.csv.second})/FluffyDisplay-#{version.csv.first}.#{version.csv.second}.zip"
  name "FluffyDisplay"
  desc "Manage virtual displays"
  homepage "https://github.com/tml1024/FluffyDisplay"

  livecheck do
    url "https://github.com/tml1024/FluffyDisplay/releases.atom"
    regex(%r{releases/tag/(.*)"}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match[0].tr("(", ",").delete(")") }
    end
  end

  app "FluffyDisplay.app"
end