class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.12.1-source.tgz"
  sha256 "59ee2118ba7b099e9d1502572c9af4221501af955103d2b687aaa3890d13325e"
  license "GPL-2.0-or-later"
  head "https://gitlab.onelab.info/gmsh/gmsh.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?gmsh[._-]v?(\d+(?:\.\d+)+)[._-]source\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ba0add32e9bd476ead54d7b4524a3d9ac315681300ec27aef5d173a2178c0f04"
    sha256 cellar: :any,                 arm64_ventura:  "9d9049265b8b927e3405f3ff876adebbcb66e4b0da34c0213a3fcc18ed7c0734"
    sha256 cellar: :any,                 arm64_monterey: "f5e091908ca1024f81a453d1d1abb3e231115a58b380462b76df7b06c4ed4fdb"
    sha256 cellar: :any,                 sonoma:         "057ecb639109270464531d9378cc160d1dee89ec0bad8d839168a7767ad2abe2"
    sha256 cellar: :any,                 ventura:        "bd9461a0a8bce8f77c3bcd6a30cd3cdd567afa3062924c43bdeba667d23a97f1"
    sha256 cellar: :any,                 monterey:       "2a7e26e97421bc1b5cccbed4542a025bdb3417e59c41e2e5be5935ddc99a4c9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13f040a68a91eaa890e5ad9d72827c7bf95f918c28a1fea70df2c47f69319004"
  end

  depends_on "cmake" => :build
  depends_on "cairo"
  depends_on "fltk"
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "opencascade"

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    ENV["CASROOT"] = Formula["opencascade"].opt_prefix

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DENABLE_OS_SPECIFIC_INSTALL=0",
                    "-DGMSH_BIN=#{bin}",
                    "-DGMSH_LIB=#{lib}",
                    "-DGMSH_DOC=#{pkgshare}/gmsh",
                    "-DGMSH_MAN=#{man}",
                    "-DENABLE_BUILD_LIB=ON",
                    "-DENABLE_BUILD_SHARED=ON",
                    "-DENABLE_NATIVE_FILE_CHOOSER=ON",
                    "-DENABLE_PETSC=OFF",
                    "-DENABLE_SLEPC=OFF",
                    "-DENABLE_OCC=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Move onelab.py into libexec instead of bin
    libexec.install bin/"onelab.py"
  end

  test do
    system "#{bin}/gmsh", "#{share}/doc/gmsh/examples/simple_geo/tower.geo", "-parse_and_exit"
  end
end