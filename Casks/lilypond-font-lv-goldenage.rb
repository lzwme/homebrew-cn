cask "lilypond-font-lv-goldenage" do
  version "1.0"
  sha256 :no_check

  url "https:github.comOpenLilyPondFontslv-goldenagearchiverefsheadsmaster.tar.gz"
  name "LV GoldenAge"
  desc "LV GoldenAge Font for LilyPond"
  homepage "https:github.comOpenLilyPondFontslv-goldenage"

  depends_on formula: "lilypond"

  source = Pathname("lv-goldenage-master")
  fonts_dir = Pathname("#{Formula["lilypond"].prefix}sharelilypond#{Formula["lilypond"].version}fonts")
  %w[11 13 14 16 18 20 23 26].each do |item|
    font source"otflv-goldenage-#{item}.otf", target: fonts_dir"otflv-goldenage-#{item}.otf"
    font source"svglv-goldenage-#{item}.svg", target: fonts_dir"svglv-goldenage-#{item}.svg"
    font source"svglv-goldenage-#{item}.woff", target: fonts_dir"svglv-goldenage-#{item}.woff"
  end
  ["GoldenAgeText", "GoldenAgeTitle"].each do |item|
    font source"supplementary-fonts#{item}.otf"
  end

  caveats "The cask #{token} may need to be reinstalled when LilyPond is updated."
end