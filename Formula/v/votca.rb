class Votca < Formula
  desc "Versatile Object-oriented Toolkit for Coarse-graining Applications"
  homepage "https:www.votca.org"
  url "https:github.comvotcavotcaarchiverefstagsv2024.1.tar.gz"
  sha256 "74d447f976a7d5c05ec65ab99f52b75379cafa3b40b8bc3b9b328f8402bc53dc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d83bd1a9c46735242047b9d00ad6e372ef8886dde8a70375c82fb96728bbc6db"
    sha256 cellar: :any,                 arm64_ventura:  "517dd32b3eac99c62b70d3ec73d724a894ebe0ca11211ba9093ca2733953f1ef"
    sha256 cellar: :any,                 arm64_monterey: "f6d189bd73aa95e2fc74c506a94d2584e6be327f7446309ff5f669f439ef7b39"
    sha256 cellar: :any,                 sonoma:         "7920055ec0096918752abbc653114a6daaa4cc68a54b72f1f584503208a3d0e8"
    sha256 cellar: :any,                 ventura:        "9100082cb7ad9bb733a2fd759c83525e00af5beea5fc7021bb91d986935e5a21"
    sha256 cellar: :any,                 monterey:       "ab8b77362943511d03947aa3b2f55146d746ba6a595e0789b0be6279c787f4fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb617d7416af23f219076b0bc6d4277036dac280d2cfcb104759dbadac5931d5"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "fftw"
  depends_on "gcc" # for OpenMP
  # add gromacs dep back once it was built with clang
  # Use hdf5@1.10: Unable to determine HDF5 CXX flags from HDF5 wrapper.
  depends_on "hdf5@1.10"
  depends_on "libecpint"
  depends_on "libint"
  depends_on "libxc"
  depends_on "numpy"
  depends_on "python@3.12"

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
    system "#{bin}csg_property", "--help"
    (testpath"table.in").write <<~EOS
      0 0 i
      1 1 i
    EOS
    system "#{bin}csg_resample", "--in", "table.in", "--out", "table.out", "--grid", "0:0.1:1", "--type", "linear"
    assert_path_exists "#{testpath}table.out"
  end
end