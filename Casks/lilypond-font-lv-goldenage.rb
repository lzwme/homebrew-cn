cask "lilypond-font-lv-goldenage" do
  version "1.0"
  sha256 :no_check

  url "https://ghfast.top/https://github.com/OpenLilyPondFonts/lv-goldenage/archive/refs/heads/master.tar.gz"
  name "LV GoldenAge"
  desc "LV GoldenAge Font for LilyPond"
  homepage "https://github.com/OpenLilyPondFonts/lv-goldenage"

  depends_on formula: "lilypond"

  source = Pathname("lv-goldenage-master")
  fonts_dir = Pathname("#{Formula["lilypond"].prefix}/share/lilypond/#{Formula["lilypond"].version}/fonts")
  %w[11 13 14 16 18 20 23 26].each do |item|
    font source/"otf/lv-goldenage-#{item}.otf", target: fonts_dir/"otf/lv-goldenage-#{item}.otf"
    font source/"svg/lv-goldenage-#{item}.svg", target: fonts_dir/"svg/lv-goldenage-#{item}.svg"
    font source/"svg/lv-goldenage-#{item}.woff", target: fonts_dir/"svg/lv-goldenage-#{item}.woff"
  end
  ["GoldenAgeText", "GoldenAgeTitle"].each do |item|
    font source/"supplementary-fonts/#{item}.otf"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end