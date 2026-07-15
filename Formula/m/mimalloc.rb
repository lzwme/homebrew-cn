class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https://github.com/microsoft/mimalloc"
  url "https://ghfast.top/https://github.com/microsoft/mimalloc/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "bee1e1546fe17bad0ec3385067b8b2862d3ce9447e8f413df2e52bfccfc0decc"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7d26ea5dcd58308fdc4eb780d756bdf13d3ec8e478315a90b55c1a5f2e6207dc"
    sha256 cellar: :any, arm64_sequoia: "cbaa134763943a7b8c0c92a39bbc993b70e1131bc821b977ee07004dcaf9efa7"
    sha256 cellar: :any, arm64_sonoma:  "641f61eac732d7e49068ca173529f634d0c5371f3d8eff7a137089b6715855f8"
    sha256 cellar: :any, sonoma:        "f12b0fe6ab7d9dd590ded8c4a93d3e365680f304ee0dbfd831a1cf6cc48065e5"
    sha256 cellar: :any, arm64_linux:   "f11cd4e8b9ae78c6b5c99aadb8e85ae108c66f195f13bb7136fc7621ee0061bc"
    sha256 cellar: :any, x86_64_linux:  "b1c29184fa35eec6695d006d186625a30a5be54eb7a82676088defc950bc19dd"
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