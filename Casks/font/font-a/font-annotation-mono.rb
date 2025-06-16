cask "font-annotation-mono" do
  version "0.2"
  sha256 "0740d05207472ea4fd34f67752f79bfd0bc473c98fe13ab1c303334c33ddf960"

  url "https:github.comqwerasd205AnnotationMonoreleasesdownloadv#{version}AnnotationMono_v#{version}.zip",
      verified: "github.comqwerasd205AnnotationMono"
  name "Annotation Mono"
  homepage "https:qwerasd205.github.ioAnnotationMono"

  no_autobump! because: :requires_manual_review

  font "distotfBlack_Oblique.otf"
  font "distotfBlack.otf"
  font "distotfBold_Oblique.otf"
  font "distotfBold.otf"
  font "distotfDemiBold_Oblique.otf"
  font "distotfDemiBold.otf"
  font "distotfExtraBlack_Oblique.otf"
  font "distotfExtraBlack.otf"
  font "distotfExtraBold_Oblique.otf"
  font "distotfExtraBold.otf"
  font "distotfExtraLight_Oblique.otf"
  font "distotfExtraLight.otf"
  font "distotfLight_Oblique.otf"
  font "distotfLight.otf"
  font "distotfMedium_Oblique.otf"
  font "distotfMedium.otf"
  font "distotfRegular_Oblique.otf"
  font "distotfRegular.otf"
  font "distotfThin_Oblique.otf"
  font "distotfThin.otf"
  font "distvariableAnnotationMono-VF.ttf"

  # No zap stanza required
end