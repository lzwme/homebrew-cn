class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https://github.com/microsoft/mimalloc"
  url "https://ghfast.top/https://github.com/microsoft/mimalloc/archive/refs/tags/v3.5.2.tar.gz"
  sha256 "db5c4aaaf356edfeb1aa236b3a052fe3c67d01419db36613f783999341ed5619"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ebf644fb37d35454111a9006c1dc1afe6fb9c5993ab42a44a02c88170c61edd9"
    sha256 cellar: :any, arm64_tahoe:       "acc2c1499a4dced8c7b1e6608e9044f62df8c9a7913e22a216ad5a6046ea1e97"
    sha256 cellar: :any, arm64_sequoia:     "d560b63e529a5605cff7d7503abb5acadca1c25892ff6b1429f2ba4112ae631d"
    sha256 cellar: :any, arm64_linux:       "3ed4a2973bb63b3af11d7bb3b0e4289ebc277bf9b3d0e01ff8b9e38d46e1d165"
    sha256 cellar: :any, x86_64_linux:      "788bcdcaa155fc6e0711b26ea50532b6f5b3f926db0c965655066cc2293d1cca"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DMI_INSTALL_TOPLEVEL=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test"
  end

  test do
    cp pkgshare/"test/main.c", testpath
    system ENV.cc, "main.c", "-L#{lib}", "-lmimalloc", "-o", "test"
    assert_match(/pages\s+peak\s+total\s+current\s+block\s+total/, shell_output("./test 2>&1"))
  end
end