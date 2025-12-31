class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://ghfast.top/https://github.com/mltframework/mlt/releases/download/v7.36.0/mlt-7.36.0.tar.gz"
  sha256 "1b0781b9563cd022b39a87528513f41ac1a18c4f594cde5d1ae264de3c8c52d7"
  license "LGPL-2.1-only"
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "4a169e932d07b108c42cb86039cfabcbbc47c884e13a545475ec432bcb2a6438"
    sha256 arm64_sequoia: "25e9a5070d4b182e836e6289ea5bd71d5fee96bf67254d00af72fe6bb521ee89"
    sha256 arm64_sonoma:  "19dccf4f839aca83c9a9a489644b0a83289633eccff357d787ad2470ce2ce975"
    sha256 sonoma:        "b4ac42d9af6646e3f0966ff8b9bfdf6d0121db288153459d7e6ca9a3f8c401ff"
    sha256 arm64_linux:   "ad5d1f9ecd9ee482d8bde81e2d07d87493fc4333c25a853894e857668f99e31d"
    sha256 x86_64_linux:  "ef1b5f533281fb5e2076e85d3d294c13d5b47a4eca85575b022a7331217abfbe"
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