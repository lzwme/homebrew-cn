cask "font-annotation-mono" do
  version "0.3"
  sha256 "a72513e0737aed6db311054ea6e18049760b060865214e74c84750b46c846325"

  url "https://ghfast.top/https://github.com/qwerasd205/AnnotationMono/releases/download/v#{version}/AnnotationMono_v#{version}.zip",
      verified: "github.com/qwerasd205/AnnotationMono/"
  name "Annotation Mono"
  homepage "https://qwerasd205.github.io/AnnotationMono/"

  font "dist/otf/Black_Oblique.otf"
  font "dist/otf/Black.otf"
  font "dist/otf/Bold_Oblique.otf"
  font "dist/otf/Bold.otf"
  font "dist/otf/DemiBold_Oblique.otf"
  font "dist/otf/DemiBold.otf"
  font "dist/otf/ExtraBlack_Oblique.otf"
  font "dist/otf/ExtraBlack.otf"
  font "dist/otf/ExtraBold_Oblique.otf"
  font "dist/otf/ExtraBold.otf"
  font "dist/otf/ExtraLight_Oblique.otf"
  font "dist/otf/ExtraLight.otf"
  font "dist/otf/Light_Oblique.otf"
  font "dist/otf/Light.otf"
  font "dist/otf/Medium_Oblique.otf"
  font "dist/otf/Medium.otf"
  font "dist/otf/Regular_Oblique.otf"
  font "dist/otf/Regular.otf"
  font "dist/otf/Thin_Oblique.otf"
  font "dist/otf/Thin.otf"
  font "dist/variable/AnnotationMono-VF.ttf"

  # No zap stanza required
end