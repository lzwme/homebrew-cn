class Votca < Formula
  desc "Versatile Object-oriented Toolkit for Coarse-graining Applications"
  homepage "https:www.votca.org"
  url "https:github.comvotcavotcaarchiverefstagsv2024.2.tar.gz"
  sha256 "704d50f64bbfa2e19d0aa4b5726ac35c20c3b9b45554be5f1e1417d430e31c24"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8216070e0f82f9e28bc8df70733f8f59867a116cc0b36d4e5ce65c9c71c0760c"
    sha256 cellar: :any,                 arm64_sonoma:  "3e3a83afb803197ee28ccc1240088a1f7ed3684dd43939e6cc95b4192cc1f81e"
    sha256 cellar: :any,                 arm64_ventura: "7b4790e5bf962a55755eeec67ce0b120b760438e539461ad5030a21f27e89d4a"
    sha256 cellar: :any,                 sonoma:        "afcc081937e406eeeb172b43e30e1a1dc0347b6a73324c9674f87d80540dbf68"
    sha256 cellar: :any,                 ventura:       "37912103d21f3e1f091ce90bbc379c2bc234323174900060075f61bc69ed9ae3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5980ca2c2e43813583fcb39890ea3a2f1dfb2376c7ad38d56124574df750c8ad"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
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
  depends_on "python@3.13"

  uses_from_macos "expat"

  on_macos do
    depends_on "libaec"
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
    system bin"csg_property", "--help"
    (testpath"table.in").write <<~EOS
      0 0 i
      1 1 i
    EOS
    system bin"csg_resample", "--in", "table.in", "--out", "table.out", "--grid", "0:0.1:1", "--type", "linear"
    assert_path_exists "#{testpath}table.out"
  end
end