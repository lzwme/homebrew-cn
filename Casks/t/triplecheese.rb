cask "triplecheese" do
  version "1.3,12092"
  sha256 "89457e5b085cb10fc1ba140b001fda214ddcd08a215292f2dc95c610a53baa03"

  url "https://dl.u-he.com/releases/TripleCheese_#{version.csv.first.no_dots}_#{version.csv.second}_Mac.zip"
  name "Triple Cheese"
  desc "Luscious and cheesy synthesiser"
  homepage "https://u-he.com/products/triplecheese/"

  livecheck do
    url "https://u-he.com/products/triplecheese/releasenotes.html"
    regex(/Triple\s*Cheese\s*(\d+(?:\.\d+)*)\s*\(revision\s*(\d+(?:\.\d+)*)\)/i)
    strategy :page_match do |page, regex|
      match = page.match(regex)
      next if match.blank?

      "#{match[1]},#{match[2]}"
    end
  end

  no_autobump! because: :requires_manual_review

  pkg "TripleCheese_#{version.csv.second}_Mac/TripleCheese #{version.csv.first}.0 Installer.pkg"

  uninstall pkgutil: [
    "com.u-he.TripleCheese.aax",
    "com.u-he.TripleCheese.au",
    "com.u-he.TripleCheese.data.pkg",
    "com.u-he.TripleCheese.documentation.pkg",
    "com.u-he.TripleCheese.presets.pkg",
    "com.u-he.TripleCheese.tuningFiles.pkg",
    "com.u-he.TripleCheese.vst",
    "com.u-he.TripleCheese.vst3",
  ]

  zap trash: [
    "~/Library/Application Support/u-he/com.u-he.TripleCheese.midiassign.txt",
    "~/Library/Application Support/u-he/com.u-he.TripleCheese.Preferences.txt",
    "~/Library/Application Support/u-he/TripleCheese",
  ]

  caveats do
    reboot
  end
end