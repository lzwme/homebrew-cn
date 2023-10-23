class Papilo < Formula
  desc "Parallel Presolve for Integer and Linear Optimization"
  homepage "https://www.scipopt.org"
  url "https://ghproxy.com/https://github.com/scipopt/papilo/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "d22e8e2e91e1967afda5cf27eaeaa4ab3d40694c7716b4d328d69a50e05d5115"
  license all_of: ["LGPL-3.0-only", "GPL-3.0-only"]
  revision 1
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "469f944fedcfb169db7c55b2e0837fb126016e1ffdf849d3b7061e5058040678"
    sha256 cellar: :any,                 arm64_ventura:  "b60ce3216a9b99c82e725d46d5eb4629922691767196215c77b313062428693b"
    sha256 cellar: :any,                 arm64_monterey: "8403692ca8e41d4e6903e5ec84884b8d87d3815d0ab616c9ea8d3775562f3189"
    sha256 cellar: :any,                 sonoma:         "131b161ee77e0bccca3e186bf5a804e91fafa9737e3ea19f4ac358e36e32af25"
    sha256 cellar: :any,                 ventura:        "b08cf2812c1903f6fd09104ac1ed7d72f0d8f13b748b713d9a35c9ad7e5d5de6"
    sha256 cellar: :any,                 monterey:       "3615edebfbc716144d0e483d319bfcbf3e9a32c72c6dae1fecbd4e570902089d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "445bf0a77af259f6ff65ab88a001732f94868003fdf606ca16d67149f6ba78a9"
  end

  depends_on "cmake" => :build
  depends_on "gcc" => :build
  depends_on "boost"
  depends_on "gmp"
  depends_on "openblas"
  depends_on "tbb"

  def install
    cmake_args = %w[
      -DBOOST=ON
      -DGMP=ON
      -DLUSOL=ON
      -DQUADMATH=ON
      -DTBB=ON
      -DBLA_VENDOR=OpenBLAS
    ]

    system "cmake", "-B", "papilo-build", "-S", ".", *cmake_args, *std_cmake_args
    system "cmake", "--build", "papilo-build"
    system "cmake", "--install", "papilo-build"

    pkgshare.install "test/instances/test.mps"
  end

  test do
    output = shell_output("#{bin}/papilo presolve -f #{pkgshare}/test.mps")
    assert_match "presolving finished after", output
  end
end