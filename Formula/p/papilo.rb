class Papilo < Formula
  desc "Parallel Presolve for Integer and Linear Optimization"
  homepage "https:www.scipopt.org"
  url "https:github.comscipoptpapiloarchiverefstagsv2.1.4.tar.gz"
  sha256 "3526f3f9a6036c4b51f324f24535b5ee63e26cbc5d3f893a765cbc9cd721fac9"
  license all_of: ["LGPL-3.0-only", "GPL-3.0-only"]
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a09d8cb1217b020438e35d4156bfabe23ed10c955fd636895c5205bc3425af41"
    sha256 cellar: :any,                 arm64_ventura:  "8b5a7a88f12b0c7f3332f957a969faf9138e5c8efb7125be31eb817590dcca74"
    sha256 cellar: :any,                 arm64_monterey: "2f1bfa478f9150ff4811765c11b180e1db6a2ee0237ef5cd52737bb489f1415c"
    sha256 cellar: :any,                 sonoma:         "1a571f68e71345ccb112ed212de92f778c8d206bdb189b66caebec2c1d1e1bc2"
    sha256 cellar: :any,                 ventura:        "dc862640cf3a6dc03a429e60b985d0765f28dee93ea189f93b2f2d4dd95cf0ac"
    sha256 cellar: :any,                 monterey:       "413d4f35c3fada9529ec6ba2d56de3d0dd4c6eb5fb5d6468a1482ad94a010e0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40df9a84e3f1a352562e30b142925f0cc30fbdb98652a9b0f2e97a9f397d7588"
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

    pkgshare.install "testinstancestest.mps"
  end

  test do
    output = shell_output("#{bin}papilo presolve -f #{pkgshare}test.mps")
    assert_match "presolving finished after", output
  end
end