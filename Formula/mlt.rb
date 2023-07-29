class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://ghproxy.com/https://github.com/mltframework/mlt/releases/download/v7.18.0/mlt-7.18.0.tar.gz"
  sha256 "9c57da14fbf3cb9c23b867b36f038aac7978c159ba0e8d8ac90e31c66878d115"
  license "LGPL-2.1-only"
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "394ba22390851d935d5280f17f4e75b87be445ddbd9be7a4db782ce5584e0420"
    sha256 arm64_monterey: "006ac2abfcd63d0cea3111e2bc428ee02ecc80f4e3eb20cbf29d12a7bc2580ce"
    sha256 arm64_big_sur:  "a571c58376630099edb76017990a6590715e48c24a0943e04fe0aaec9700afe1"
    sha256 ventura:        "fddb9c34eab9067d1dcb92d6d9a8d96cbea2006c610138d4997f986ffda26b2b"
    sha256 monterey:       "55bdc7443a18a6c988e74b634eb1ed301eff4485b19d66618f29b01fa44134fe"
    sha256 big_sur:        "0710524da8223ccb4c97b460c1f3292e616aa30dcdd51c8aea1701cfe99b7552"
    sha256 x86_64_linux:   "ec26ed38488fe349f8531043ae5123c2d584c7aa36cb06ac0bc245ca3e228d74"
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
  depends_on "qt@5"
  depends_on "sdl2"
  depends_on "sox"

  fails_with gcc: "5"

  def install
    rpaths = [rpath, rpath(source: lib/"mlt")]

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}",
                    "-DGPL=ON",
                    "-DGPL3=ON",
                    "-DMOD_OPENCV=ON",
                    "-DMOD_JACKRACK=OFF",
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