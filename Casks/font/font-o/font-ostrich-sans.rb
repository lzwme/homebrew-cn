cask "font-ostrich-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comtheleagueofostrich-sansarchiverefsheadsmaster.tar.gz",
      verified: "github.comtheleagueofostrich-sans"
  name "Ostrich Sans"
  homepage "https:www.theleagueofmoveabletype.comostrich-sans"

  font "ostrich-sans-masterOstrichSans-Black.otf"
  font "ostrich-sans-masterOstrichSans-Bold.otf"
  font "ostrich-sans-masterOstrichSans-Heavy.otf"
  font "ostrich-sans-masterOstrichSans-Light.otf"
  font "ostrich-sans-masterOstrichSans-Medium.otf"
  font "ostrich-sans-masterOstrichSansDashed-Medium.otf"
  font "ostrich-sans-masterOstrichSansInline-Italic.otf"
  font "ostrich-sans-masterOstrichSansInline-Regular.otf"
  font "ostrich-sans-masterOstrichSansRounded-Medium.otf"

  # No zap stanza required
end