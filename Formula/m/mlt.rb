class Mlt < Formula
  desc "Author, manage, and run multitrack audiovideo compositions"
  homepage "https:www.mltframework.org"
  url "https:github.commltframeworkmltreleasesdownloadv7.28.0mlt-7.28.0.tar.gz"
  sha256 "bc425bf9602213f5f4855b78cfbbcd43eeb78097c508588bde44415963955aa1"
  license "LGPL-2.1-only"
  revision 1
  head "https:github.commltframeworkmlt.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:  "f00c9c76c5bc5a751ce1624e0772c585c709f44875d82440c0a388dbb09cdde9"
    sha256 arm64_ventura: "e643461ac282fb5edddcb7ff631756018442fbb42049386cdeead1031eb061be"
    sha256 sonoma:        "4c32850aaf200194157ca6dab467effb8095058f6f31036d16d076ea5cced641"
    sha256 ventura:       "565336d117b263f8a0aaffc764d9d1e6f10d70d599023aa6b37dc83815491441"
    sha256 x86_64_linux:  "dbea62eda468a8117ef1f61cba567c1927ec88c7992c7c70b80ef8e863d59262"
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