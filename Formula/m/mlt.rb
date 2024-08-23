class Mlt < Formula
  desc "Author, manage, and run multitrack audiovideo compositions"
  homepage "https:www.mltframework.org"
  url "https:github.commltframeworkmltreleasesdownloadv7.24.0mlt-7.24.0.tar.gz"
  sha256 "8cde7c22a1a5395abe913976c2edafb498f81ed81a5f49dd0e6e2d86d68bcec0"
  license "LGPL-2.1-only"
  revision 2
  head "https:github.commltframeworkmlt.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "d56d557f97cbf0939bf2e316b78d00e98c2fb88a140efd4336712498efce063f"
    sha256 arm64_ventura:  "50bab13d78c6dd8c5316a4e97d4963b79da1626d2d7139f060f5abefda0bbad6"
    sha256 arm64_monterey: "1ef8d67923f186ccda9ed53738ada47a07baf0855c6bf287e530a5d38e0b60a9"
    sha256 sonoma:         "f52c1f9d905048b40565d7ac009ff1a7ee1b67ecfebb12e8e8ac4ec1d5e485de"
    sha256 ventura:        "be82bc305f102d45d888c2c23fde0f0a6896221096a4fb333a66ee16b19d0a73"
    sha256 monterey:       "9fcd5bfaa4b0dfe123d903dc31e917bef9b5e273236c54ff29ad5b087f181355"
    sha256 x86_64_linux:   "4728455bcc81255b086f0bc7ac1856252134adbcb2f622552e24fac59dde9a24"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

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

  fails_with gcc: "5"

  def install
    rpaths = [rpath, rpath(source: lib"mlt")]

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
    (lib"pkgconfig").install_symlink "mlt++-#{version.major}.pc" => "mlt++.pc"
  end

  test do
    assert_match "help", shell_output("#{bin}melt -help")
  end
end