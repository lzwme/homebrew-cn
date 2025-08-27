class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://ghfast.top/https://github.com/mltframework/mlt/releases/download/v7.32.0/mlt-7.32.0.tar.gz"
  sha256 "1ca5aadfe27995c879b9253b3a48d1dcc3b1247ea0b5620b087d58f5521be028"
  license "LGPL-2.1-only"
  revision 2
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:  "9338efdb2557b5cc2546cab746f6e6449fc59dc02823ec09c0a2fad12b257c85"
    sha256 arm64_ventura: "d16ef9f107f61ff5c73bc77b9a2032de4040ca30805bad2976563a71a2ef0510"
    sha256 sonoma:        "ef1acf17b19e5b45fc08604b80cb2a29890c49108d547d2de07d54e097140c7b"
    sha256 ventura:       "a75efcbcba467fd0bdeea2551a12c6b257d4403c3e1206541740566964e1db37"
    sha256 x86_64_linux:  "7521c46bd6047d5dd1c394f0a68127b159476f0f902f3a208fb4bad58224b1fd"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "ffmpeg@7"
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
  depends_on "qt"
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