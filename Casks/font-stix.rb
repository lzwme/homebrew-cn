cask "font-stix" do
  version "2.13"
  sha256 "c4671ec4a116d887c8ebf91b2706301bebc43e776ac00f549c36ad1f34964c98"

  url "https:github.comstipubstixfontsarchivev#{version}.tar.gz",
      verified: "github.comstipubstixfonts"
  name "STIX"
  desc "Unicode fonts for scientific, technical, and mathematical texts"
  homepage "https:stixfonts.org"

  font "stixfonts-#{version}fontsstatic_otfSTIXTwoMath-Regular.otf"
  font "stixfonts-#{version}fontsstatic_otfSTIXTwoText-Bold.otf"
  font "stixfonts-#{version}fontsstatic_otfSTIXTwoText-BoldItalic.otf"
  font "stixfonts-#{version}fontsstatic_otfSTIXTwoText-Italic.otf"
  font "stixfonts-#{version}fontsstatic_otfSTIXTwoText-Medium.otf"
  font "stixfonts-#{version}fontsstatic_otfSTIXTwoText-MediumItalic.otf"
  font "stixfonts-#{version}fontsstatic_otfSTIXTwoText-Regular.otf"
  font "stixfonts-#{version}fontsstatic_otfSTIXTwoText-SemiBold.otf"
  font "stixfonts-#{version}fontsstatic_otfSTIXTwoText-SemiBoldItalic.otf"

  # No zap stanza required
end