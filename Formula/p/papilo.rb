class Papilo < Formula
  desc "Parallel Presolve for Integer and Linear Optimization"
  homepage "https:www.scipopt.org"
  url "https:github.comscipoptpapiloarchiverefstagsv2.4.1.tar.gz"
  sha256 "42f27b6d76f4d68f2c19f0a4d19e77f9bf3d271ccef2ff9303b58f8107e28aa1"
  license all_of: ["LGPL-3.0-only", "GPL-3.0-only"]
  revision 1
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6860e6b1e457b8effe9f9720a9c1e3168eeed9105cc46fa31fcb9bd6a15973d4"
    sha256 cellar: :any,                 arm64_sonoma:  "3121732cde480afa4d0f59f2b25df5a04ec447ee262613332224734e7fb93a08"
    sha256 cellar: :any,                 arm64_ventura: "57185fa7ca4c61a4c8c1deed733a8bc190c26ff4cb4f141e451ea53b3d3b4d92"
    sha256 cellar: :any,                 sonoma:        "98f60b859ba562c3ba817cd8fe124135e56de95b46c0357e7d74b849656ebc57"
    sha256 cellar: :any,                 ventura:       "10c4e34121917d0e5b3d08d7cdef7b25249ecdb9cddc2d6c6d851a88f956c54b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9472684b1ba06d4bb6fe1de0004086adb83d5993ac4d165db8ee1e248025e5a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b63cb9dfe575deb4006a5954c6a64d0ab27faa14dcd07606ca99cb8beb8968fc"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gcc"
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