class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https://github.com/microsoft/mimalloc"
  url "https://ghproxy.com/https://github.com/microsoft/mimalloc/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "86e5e53e38bace59a9eb20d27e7bd7c5f448cb246a887d4f99478fa4809731fc"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "db2cd00cdfb2a6237a3fec9a80dc2889a2a2c749ea85bcf851537cdbba5176fe"
    sha256 cellar: :any,                 arm64_monterey: "52beebc1101436f04b1044e066408c04ac4dea85e1b74b8a0bb4053553b1c6c6"
    sha256 cellar: :any,                 arm64_big_sur:  "cb3b8ee3021fc97077879b234503dc92605ca15000b0c0685af56776a55102ab"
    sha256 cellar: :any,                 ventura:        "ef5135bc8da2c0ef054f9b676fb678cdbd478e10b8b9a31290766fff2232588b"
    sha256 cellar: :any,                 monterey:       "7e123b34de8bb808c46be61bf7731b7648f11b7fdcb14ec6c291bef943eeda0d"
    sha256 cellar: :any,                 big_sur:        "78920270c02109da9ceb9cda62dad8815b562e7a9bd6fd8ac353421a3cfb89e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f3895692e504aa941e9fbe09b83841a90b88e359edbe6fa6513f9afb805a8f0"
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
    assert_match "heap stats", shell_output("./test 2>&1")
  end
end