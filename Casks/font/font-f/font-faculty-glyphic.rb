cask "font-faculty-glyphic" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflfacultyglyphicFacultyGlyphic-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Faculty Glyphic"
  homepage "https:fonts.google.comspecimenFaculty+Glyphic"

  font "FacultyGlyphic-Regular.ttf"

  # No zap stanza required
end