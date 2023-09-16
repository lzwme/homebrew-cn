cask "cockatrice" do
  on_mojave :or_older do
    version "2.8.0,2021-01-26,Prismatic.Bridge"
    sha256 "53a4db3e3b97196b42c20959da701de5713f0811907d07ba187192f53fccef1d"

    url "https://ghproxy.com/https://github.com/Cockatrice/Cockatrice/releases/download/#{version.csv.second}-Release-#{version.csv.first}/Cockatrice-#{version.csv.third}-#{version.csv.first}-macOS-10.14_Mojave.dmg",
        verified: "github.com/Cockatrice/Cockatrice/"
  end
  on_catalina do
    version "2.9.0,2023-09-14,Rings.of.the.Wild"
    sha256 "ca4bed42a54a90b1c15387134e29660a52507af7a691c6c136a4f64c57b0f1ed"

    url "https://ghproxy.com/https://github.com/Cockatrice/Cockatrice/releases/download/#{version.csv.second}-Release-#{version.csv.first}/Cockatrice-#{version.csv.third}-#{version.csv.first}-macOS-10.15_Catalina.dmg",
        verified: "github.com/Cockatrice/Cockatrice/"
  end
  on_big_sur :or_newer do
    version "2.9.0,2023-09-14,Rings.of.the.Wild"
    sha256 "4524c5b95928e88073d1f8be46d881288d6d0bf07d8e65185fbebc0491f29e08"

    url "https://ghproxy.com/https://github.com/Cockatrice/Cockatrice/releases/download/#{version.csv.second}-Release-#{version.csv.first}/Cockatrice-#{version.csv.third}-#{version.csv.first}-macOS-11_Big_Sur.dmg",
        verified: "github.com/Cockatrice/Cockatrice/"
  end

  name "Cockatrice"
  desc "Virtual tabletop for multiplayer card games"
  homepage "https://cockatrice.github.io/"

  livecheck do
    url "https://github.com/Cockatrice/Cockatrice/releases/latest/"
    regex(%r{href=".*?/(\d+(?:-\d+)+)-Release-(\d+(?:\.\d+)+)/Cockatrice-([^/]+)-\2-macOS-[.\w]*\.dmg"}i)
    strategy :header_match do |headers, regex|
      next if headers["location"].blank?

      # Identify the latest tag from the response's `location` header
      latest_tag = File.basename(headers["location"])
      next if latest_tag.blank?

      # Fetch the assets list HTML for the latest tag and match within it
      assets_page = Homebrew::Livecheck::Strategy.page_content(
        @url.sub(%r{/releases/?.+}, "/releases/expanded_assets/#{latest_tag}"),
      )
      assets_page[:content]&.scan(regex)&.map { |match| "#{match[1]},#{match[0]},#{match[2]}" }
    end
  end

  depends_on macos: ">= :mojave"

  app "cockatrice.app"
  app "oracle.app"
  app "servatrice.app"

  uninstall quit: [
    "com.cockatrice.cockatrice",
    "com.cockatrice.oracle",
    "com.cockatrice.servatrice",
  ]

  zap trash: [
    "~/Library/Application Support/Cockatrice",
    "~/Library/Preferences/com.cockatrice.Cockatrice.plist",
    "~/Library/Preferences/com.cockatrice.oracle.plist",
    "~/Library/Preferences/de.cockatrice.Cockatrice.plist",
    "~/Library/Saved Application State/com.cockatrice.cockatrice.savedState",
    "~/Library/Saved Application State/com.cockatrice.oracle.savedState",
  ]
end