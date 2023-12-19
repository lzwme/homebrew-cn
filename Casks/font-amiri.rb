cask "font-amiri" do
  version "1.000"
  sha256 "926fe1bd7dfde8e55178281f645258bfced6420c951c6f2fd532fd21691bca30"

  url "https:github.comalif-typeamirireleasesdownload#{version}Amiri-#{version}.zip",
      verified: "github.comalif-typeamiri"
  name "Amiri"
  desc "Classical Arabic typeface in Naskh style"
  homepage "https:www.amirifont.org"

  deprecate! date: "2023-12-17", because: :discontinued

  font "Amiri-#{version}Amiri-Bold.ttf"
  font "Amiri-#{version}Amiri-BoldItalic.ttf"
  font "Amiri-#{version}Amiri-Italic.ttf"
  font "Amiri-#{version}Amiri-Regular.ttf"
  font "Amiri-#{version}AmiriQuran.ttf"
  font "Amiri-#{version}AmiriQuranColored.ttf"

  # No zap stanza required
end