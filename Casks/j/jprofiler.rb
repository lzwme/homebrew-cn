cask "jprofiler" do
  version "15.0.2"
  sha256 "06185b0e09da7fe5edbe3527173f1875b19c5e2385779017ec002b57771d1728"

  url "https://download-gcdn.ej-technologies.com/jprofiler/jprofiler_macos_#{version.dots_to_underscores}.dmg"
  name "JProfiler"
  desc "Java profiler"
  homepage "https://www.ej-technologies.com/jprofiler"

  livecheck do
    url "https://www.ej-technologies.com/feeds/jprofiler"
    regex(/JProfiler\s*Release\s*v?(\d+(?:\.\d+)+)/i)
    strategy :xml do |xml, regex|
      xml.get_elements("//title").map do |item|
        match = item.text&.strip&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  app "JProfiler.app"

  zap trash: [
    "~/.jprofiler*",
    "~/Library/Preferences/com.jprofiler.history.plist",
    "~/Library/Preferences/com.jprofiler.v*.plist",
    "~/Library/Preferences/jprofiler.vmoptions",
  ]
end