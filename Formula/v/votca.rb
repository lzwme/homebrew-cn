class Votca < Formula
  desc "Versatile Object-oriented Toolkit for Coarse-graining Applications"
  homepage "https:www.votca.org"
  url "https:github.comvotcavotcaarchiverefstagsv2023.tar.gz"
  sha256 "ac78d2eb5a6694b76878d2ab1ec86bb161765143a447cc23905cdcb2bb6743be"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "786d030d23ad69cb3f00ba8850cc2100ee40011751e17e8a88a3d4111f25f659"
    sha256 cellar: :any,                 arm64_ventura:  "0edbdfe8a1455a72a05122a74bd754945863a72ea28769f3b4736486b626bc72"
    sha256 cellar: :any,                 arm64_monterey: "5197590475a1f38071f216099c2d7bcdaff8080a3553dbb51a2233dca8cd787f"
    sha256 cellar: :any,                 sonoma:         "0a0e8b708dd50693ce9966fbcac1b0cf2def32d4f1f68e4edf357df0db784326"
    sha256 cellar: :any,                 ventura:        "6a50eb224d56e2996c11f7c9c2e5b110791e2867cfa093427960307a4128c730"
    sha256 cellar: :any,                 monterey:       "17cc9392804d260c2d8954c210c52073ef701de7e52f288b6e1717ad93d5d9c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a9ffb0e61cb4979592dcc61db2215633b48ad9b8d020222579f932b4981d93d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "fftw"
  depends_on "gcc" # for OpenMP
  # add gromacs dep back once it was built with clang
  depends_on "hdf5"
  depends_on "libecpint"
  depends_on "libint"
  depends_on "libxc"
  depends_on "numpy"
  depends_on "python@3.11"

  uses_from_macos "expat"

  on_macos do
    depends_on "libomp"
  end

  def install
    args = [
      "-DINSTALL_RC_FILES=OFF",
      "-DINSTALL_CSGAPPS=ON",
      "-DBUILD_XTP=ON",
      "-DCMAKE_DISABLE_FIND_PACKAGE_GROMACS=ON",
      "-DENABLE_RPATH_INJECT=ON",
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}csg_property", "--help"
    (testpath"table.in").write <<~EOS
      0 0 i
      1 1 i
    EOS
    system "#{bin}csg_resample", "--in", "table.in", "--out", "table.out", "--grid", "0:0.1:1", "--type", "linear"
    assert_path_exists "#{testpath}table.out"
  end
end