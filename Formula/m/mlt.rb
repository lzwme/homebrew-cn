class Mlt < Formula
  desc "Author, manage, and run multitrack audiovideo compositions"
  homepage "https:www.mltframework.org"
  url "https:github.commltframeworkmltreleasesdownloadv7.28.0mlt-7.28.0.tar.gz"
  sha256 "bc425bf9602213f5f4855b78cfbbcd43eeb78097c508588bde44415963955aa1"
  license "LGPL-2.1-only"
  revision 2
  head "https:github.commltframeworkmlt.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:  "b1aef4cc072bffac39aa511f654a229e85ed611f461f9c010a6d00157aacecc9"
    sha256 arm64_ventura: "73a29ba52aa5dd6870be20ce8baab62b9436f070a193484560dc5489d30882ce"
    sha256 sonoma:        "a7575025e77de6e703d62f097a6b524a65c00704e48f09cbb34f7d6c7b878ee6"
    sha256 ventura:       "0aa0749cca95e28f1bd5f982b28904abc98c45858f77d2106493d81873baa971"
    sha256 x86_64_linux:  "c8a9f00d0c0c680be2853c80a81d931adf2ccd374bf0f01411124b77a8a01b57"
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