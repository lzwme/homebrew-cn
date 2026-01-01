class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://ghfast.top/https://github.com/mltframework/mlt/releases/download/v7.36.1/mlt-7.36.1.tar.gz"
  sha256 "0d2b956864ba2ff58bb4e2b2779aa36870bd2a3a835e2dbfda33faa5fc6f4d3a"
  license "LGPL-2.1-only"
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "ed4e10cf63432b479d5038108f7c796a22cac71614dd2882a3a67ed41a822c51"
    sha256 arm64_sequoia: "0a0a9262a7548b041b3fe31be5a5cd5c8190222424b0ed7db8be698a2664e3dc"
    sha256 arm64_sonoma:  "307840b08a0724a8d81691609cb37a2009aa42f398460b16f1772fce0a620f16"
    sha256 sonoma:        "917126f1c059ca4353cced42fcdb55855cd7f362dc35a641077cc130a98ff6b3"
    sha256 arm64_linux:   "becc8c27854025844d09143aa285cc66a0fe18667b8b2bdef83753b8c4173cf2"
    sha256 x86_64_linux:  "2dab5a8a55ff64f8939dc2fe2304965642313b389e25cc2e76659f3e7b939113"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "ffmpeg"
  depends_on "fftw"
  depends_on "fontconfig"
  depends_on "frei0r"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "libdv"
  depends_on "libexif"
  depends_on "libsamplerate"
  depends_on "libvidstab"
  depends_on "libvorbis"
  depends_on "opencv"
  depends_on "pango"
  depends_on "qt5compat"
  depends_on "qtbase"
  depends_on "qtsvg"
  depends_on "rubberband"
  depends_on "sdl2"
  depends_on "sox"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "freetype"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "pulseaudio"
  end

  def install
    rpaths = [rpath, rpath(source: lib/"mlt")]

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}",
                    "-DGPL=ON",
                    "-DGPL3=ON",
                    "-DMOD_JACKRACK=OFF",
                    "-DMOD_OPENCV=ON",
                    "-DMOD_QT5=OFF",
                    "-DMOD_QT6=ON",
                    "-DMOD_SDL1=OFF",
                    "-DMOD_MOVIT=OFF",
                    "-DRELOCATABLE=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Workaround as current `mlt` doesn't provide an unversioned mlt++.pc file.
    # Remove if mlt readds or all dependents (e.g. `synfig`) support versioned .pc
    (lib/"pkgconfig").install_symlink "mlt++-#{version.major}.pc" => "mlt++.pc"
  end

  test do
    assert_match "help", shell_output("#{bin}/melt -help")
  end
end