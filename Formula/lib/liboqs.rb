class Liboqs < Formula
  desc "Library for quantum-safe cryptography"
  homepage "https:openquantumsafe.org"
  url "https:github.comopen-quantum-safeliboqsarchiverefstags0.9.2.tar.gz"
  sha256 "a708c058d4d9dcf5568245439b526fa480180f1fa4541adf21b1d094dc9e0590"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5fb629a03656c68c49b99f9daf0ebc580928090046210729a00b9c35c09b8a50"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "418035892a17e36adb088fda0d1c5afdbced280a32e60e384a675e7a16775d1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05786a72a882d6afb5ce32ce5699f88b6e802f9b05c6c38db5ae390492537eef"
    sha256 cellar: :any_skip_relocation, sonoma:         "b158e4860040b89aa9a2c53aeda5bc17232c1e593f8d285c4cd60dc12d4cfbb8"
    sha256 cellar: :any_skip_relocation, ventura:        "a013201bffd4da33ee70dba4dcd8435916a7356910a1d3f62cd86a453c88c5b7"
    sha256 cellar: :any_skip_relocation, monterey:       "3446fd5382ff0895b2b1753ab2c655492cd7be00a3c976ffa879e2a25fedf4ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8541d89d46cd4d88179b86d611297ed76c879e345a640986e77dfed6180ae67"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "ninja" => :build
  depends_on "openssl@3"

  fails_with gcc: "5"

  def install
    args = %W[
      -DOQS_USE_OPENSSL=ON
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "tests"
  end

  test do
    cp pkgshare"testsexample_kem.c", "test.c"
    system ENV.cc, "test.c",
                  "-I#{Formula["openssl@3"].include}", "-I#{include}",
                  "-L#{Formula["openssl@3"].lib}", "-L#{lib}",
                  "-loqs", "-lssl", "-lcrypto", "-o", "test"
    assert_match "operations completed", shell_output(".test")
  end
end