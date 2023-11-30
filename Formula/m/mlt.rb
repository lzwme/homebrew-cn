class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://ghproxy.com/https://github.com/mltframework/mlt/releases/download/v7.22.0/mlt-7.22.0.tar.gz"
  sha256 "7cf4d9573a061d76902c6e12a2f09f5f461e7c697635233df82a63a3fe4d6da6"
  license "LGPL-2.1-only"
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "2d53a87659cb1ab91f4d26c5300ec2c31596c319d3316eb51b409a1bf040af24"
    sha256 arm64_ventura:  "9995a145304b07405cace3670f52004ab6799a58b3919a83335681e85c63c8c8"
    sha256 arm64_monterey: "0851982a20f6e3ca69cecda78fa401a74bf1aa28fac297113517c54cb22e0096"
    sha256 sonoma:         "5378fc27f1e03873e45eced86bcb519077849cf414802f91872855be2ae652af"
    sha256 ventura:        "adc6c07b2d4c2a99e868d3cf11b858723d4dc4911d1dfa51a1373f93d9125f4c"
    sha256 monterey:       "89f16b6677b4529ccfe0d060da473cce664ba08ee5817a688c3d308ae7404c21"
    sha256 x86_64_linux:   "eae8840dbd4594948716a9358da63dad0fabae6f528c02959ef707c93857b93d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "fftw"
  depends_on "frei0r"
  depends_on "gdk-pixbuf"
  depends_on "libdv"
  depends_on "libexif"
  depends_on "libsamplerate"
  depends_on "libvorbis"
  depends_on "opencv"
  depends_on "pango"
  depends_on "qt"
  depends_on "sdl2"
  depends_on "sox"

  fails_with gcc: "5"

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