class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https://github.com/microsoft/mimalloc"
  url "https://ghfast.top/https://github.com/microsoft/mimalloc/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "37107a52c16baa80c5f74861dddda7b27bb9949e41a6637691867a94c88ca446"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "102e6087d86f2bd0324fd926d2e97b7329670adb24e028c6785ba350fbed84bd"
    sha256 cellar: :any, arm64_sequoia: "22b29dce5a118986abcb2000646a99c2b1de909ff45c266d39bd04b3b5f4a24b"
    sha256 cellar: :any, arm64_sonoma:  "030ce1c85c35ddcc9dca3db27953476f440252b0f8f88f8d93aa4cd9f65dab7c"
    sha256 cellar: :any, sonoma:        "b470207ad5937c5add4b742b25940dbc52bf0f59c40ed6b9135877d534fa7ef6"
    sha256 cellar: :any, arm64_linux:   "4e775a13647c367a5ef0183f8b82149bc459bedddcf8682449787bf8125bb786"
    sha256 cellar: :any, x86_64_linux:  "0bdbee150dc52baa640ff063c862f7b34f7560041b9388d6cc592f98f0dac879"
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