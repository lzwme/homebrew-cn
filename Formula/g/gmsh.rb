class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  license "GPL-2.0-or-later"
  revision 3
  head "https://gitlab.onelab.info/gmsh/gmsh.git", branch: "master"

  stable do
    url "https://gmsh.info/src/gmsh-4.13.1-source.tgz"
    sha256 "77972145f431726026d50596a6a44fb3c1c95c21255218d66955806b86edbe8d"

    # Backport fix for newer fltk
    patch do
      url "https://gitlab.onelab.info/gmsh/gmsh/-/commit/3b3f0f7e16430939b345889a9e31b50104d5baf3.diff"
      sha256 "194b2822123c36e18260db5c14b98127c2a6721de2f5272bd0bd9456580465c3"
    end
  end

  livecheck do
    url :homepage
    regex(/href=.*?gmsh[._-]v?(\d+(?:\.\d+)+)[._-]source\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f3a1e40de95ab46acc5ac50e87dd5b0faf1ecdf4cb44829909e65fb13419f81d"
    sha256 cellar: :any,                 arm64_sonoma:  "68e0199110b83ebe53d765ac46f4a9efed10020b5acd4982b064bb16a4d88416"
    sha256 cellar: :any,                 arm64_ventura: "5ba12aaf463673839cfec13a4ec5e488fb00db19010678c140fc6dfb3c217263"
    sha256 cellar: :any,                 sonoma:        "7045a9dc996683f1f6ee02300ec61fa08d52c1154a16a5c9c329ad1a113f3dc1"
    sha256 cellar: :any,                 ventura:       "d5870e45349737e9a3fb0e8b7d9cd52aff3a8b6ccb4212953b8897ebd6f9af51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d95c744bda9ff11d63447ed1a86907be4f5d9ca4498365d0f1e86634314fe2d"
  end

  depends_on "cmake" => :build
  depends_on "cairo"
  depends_on "fltk"
  depends_on "gcc" # for gfortran
  depends_on "gmp"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "open-mpi"
  depends_on "opencascade"

  uses_from_macos "zlib"

  on_macos do
    depends_on "freetype"
  end

  on_linux do
    depends_on "libx11"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    ENV["CASROOT"] = Formula["opencascade"].opt_prefix

    args = %W[
      -DENABLE_OS_SPECIFIC_INSTALL=0
      -DGMSH_BIN=#{bin}
      -DGMSH_LIB=#{lib}
      -DGMSH_DOC=#{pkgshare}/gmsh
      -DGMSH_MAN=#{man}
      -DENABLE_BUILD_LIB=ON
      -DENABLE_BUILD_SHARED=ON
      -DENABLE_NATIVE_FILE_CHOOSER=ON
      -DENABLE_PETSC=OFF
      -DENABLE_SLEPC=OFF
      -DENABLE_OCC=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Move onelab.py into libexec instead of bin
    libexec.install bin/"onelab.py"
  end

  test do
    system bin/"gmsh", share/"doc/gmsh/examples/simple_geo/tower.geo", "-parse_and_exit"
  end
end