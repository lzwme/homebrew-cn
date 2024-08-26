class Mlt < Formula
  desc "Author, manage, and run multitrack audiovideo compositions"
  homepage "https:www.mltframework.org"
  url "https:github.commltframeworkmltreleasesdownloadv7.26.0mlt-7.26.0.tar.gz"
  sha256 "4af8d6eeaf6bdb13d813abd9e7f220f6b2f1e0fd943cc92ac0cf22775e767343"
  license "LGPL-2.1-only"
  head "https:github.commltframeworkmlt.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "8e9bc3dc9a1e5e0e31cbb773903375427b6f731b0194602e33fd517e757aa7e6"
    sha256 arm64_ventura:  "78a2ad75fd55e5f3c721318e78b7a70f7d3b2bd64b0d51f6197458d4a76e69a7"
    sha256 arm64_monterey: "81b3945f33ae525d312b53054a3f6ebe2f240b2ed23d2e5bbd78d2a88fd8172f"
    sha256 sonoma:         "0d081846f4dbbf9b1272a7a08044b0b46dbcd1ea17733d31d038807df4f748da"
    sha256 ventura:        "f3253f5ed4fd4b7089309ca092eaf3f449bbcacd1d86afc7f0db27de1dde42e5"
    sha256 monterey:       "800f11dcec34bd90c12d2fcdc69355f511f8aab46f0ba18db8d285fd7cf5c7e0"
    sha256 x86_64_linux:   "f8696cbec063d6ba3f1db543e29e09c40566ccafd286c5d8bfee9f6decee3dcf"
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