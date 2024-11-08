cask "font-new-computer-modern" do
  version "7.0.0"
  sha256 "607c558ed73ed07df3b4be4a837c394d0cfb4e6206c1570c1064466162a0713e"

  url "https://download.gnu.org.ua/release/newcm/newcm-#{version}.txz"
  name "New Computer Modern"
  homepage "https://git.gnu.org.ua/newcm.git/about/"

  livecheck do
    url "https://download.gnu.org.ua/release/newcm/"
    regex(/href=.*?newcm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  font "newcm-#{version}/otf/NewCM08-Book.otf"
  font "newcm-#{version}/otf/NewCM08-BookItalic.otf"
  font "newcm-#{version}/otf/NewCM08-Italic.otf"
  font "newcm-#{version}/otf/NewCM08-Regular.otf"
  font "newcm-#{version}/otf/NewCM08Devanagari-Book.otf"
  font "newcm-#{version}/otf/NewCM08Devanagari-Regular.otf"
  font "newcm-#{version}/otf/NewCM10-Bold.otf"
  font "newcm-#{version}/otf/NewCM10-BoldItalic.otf"
  font "newcm-#{version}/otf/NewCM10-Book.otf"
  font "newcm-#{version}/otf/NewCM10-BookItalic.otf"
  font "newcm-#{version}/otf/NewCM10-Italic.otf"
  font "newcm-#{version}/otf/NewCM10-Regular.otf"
  font "newcm-#{version}/otf/NewCM10Devanagari-Bold.otf"
  font "newcm-#{version}/otf/NewCM10Devanagari-Book.otf"
  font "newcm-#{version}/otf/NewCM10Devanagari-Regular.otf"
  font "newcm-#{version}/otf/NewCMMath-Bold.otf"
  font "newcm-#{version}/otf/NewCMMath-Book.otf"
  font "newcm-#{version}/otf/NewCMMath-Regular.otf"
  font "newcm-#{version}/otf/NewCMMono10-Bold.otf"
  font "newcm-#{version}/otf/NewCMMono10-BoldOblique.otf"
  font "newcm-#{version}/otf/NewCMMono10-Book.otf"
  font "newcm-#{version}/otf/NewCMMono10-BookItalic.otf"
  font "newcm-#{version}/otf/NewCMMono10-Italic.otf"
  font "newcm-#{version}/otf/NewCMMono10-Regular.otf"
  font "newcm-#{version}/otf/NewCMSans08-Book.otf"
  font "newcm-#{version}/otf/NewCMSans08-BookOblique.otf"
  font "newcm-#{version}/otf/NewCMSans08-Oblique.otf"
  font "newcm-#{version}/otf/NewCMSans08-Regular.otf"
  font "newcm-#{version}/otf/NewCMSans10-Bold.otf"
  font "newcm-#{version}/otf/NewCMSans10-BoldOblique.otf"
  font "newcm-#{version}/otf/NewCMSans10-Book.otf"
  font "newcm-#{version}/otf/NewCMSans10-BookOblique.otf"
  font "newcm-#{version}/otf/NewCMSans10-Oblique.otf"
  font "newcm-#{version}/otf/NewCMSans10-Regular.otf"
  font "newcm-#{version}/otf/NewCMSansMath-Regular.otf"
  font "newcm-#{version}/otf/NewCMUncial08-Bold.otf"
  font "newcm-#{version}/otf/NewCMUncial08-Book.otf"
  font "newcm-#{version}/otf/NewCMUncial08-Regular.otf"
  font "newcm-#{version}/otf/NewCMUncial10-Bold.otf"
  font "newcm-#{version}/otf/NewCMUncial10-Book.otf"
  font "newcm-#{version}/otf/NewCMUncial10-Regular.otf"

  # No zap stanza required
end