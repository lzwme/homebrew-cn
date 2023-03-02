class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.11.1-source.tgz"
  sha256 "c5fe1b7cbd403888a814929f2fd0f5d69e27600222a18c786db5b76e8005b365"
  license "GPL-2.0-or-later"
  head "https://gitlab.onelab.info/gmsh/gmsh.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?gmsh[._-]v?(\d+(?:\.\d+)+)[._-]source\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0db350e10e50d6bcb4beb97912d2ae4cc4d27b1024167dda517ad4a1f03a58cb"
    sha256 cellar: :any,                 arm64_monterey: "7deec3401c4687d2a8a588c825e5b5066c0a00a48b1d3cb56c7bf594000cbcc4"
    sha256 cellar: :any,                 arm64_big_sur:  "9df46a33ad58e99a8ceb25f2e8c20791e29d1b431888e7be604efe58f02f01bd"
    sha256 cellar: :any,                 ventura:        "0d28989659a80d5f9c5c9a45d9e7814dec198994ff0bcf8a80ca598fd69d1639"
    sha256 cellar: :any,                 monterey:       "0ae614d82355c5835690ab5992771e563ff5f8e47406542a01168e3bd05cbb60"
    sha256 cellar: :any,                 big_sur:        "af5fe39a97cbd841df917b30f0ad3651ee77c60e4dfa1c343a7ceaf7caaaa4ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "548b2f8fd24e3add5e3f9dbf54216451045c658e096ff31fd2244d7a106572c4"
  end

  depends_on "cmake" => :build
  depends_on "cairo"
  depends_on "fltk"
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "opencascade"

  def install
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