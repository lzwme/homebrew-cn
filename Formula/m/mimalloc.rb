class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https://github.com/microsoft/mimalloc"
  url "https://ghfast.top/https://github.com/microsoft/mimalloc/archive/refs/tags/v3.2.6.tar.gz"
  sha256 "bd5756fb2e9f5c275b37ce1d530ac1c98baca0bad6818dcda5c83d6139108a97"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "32cc058087bc7655b7f8f72d0cee7f0a6a8550d28619b8c2ff0eb20325439ff3"
    sha256 cellar: :any,                 arm64_sequoia: "cdbf4038ef60c9d232ab78c55f0097433d94925a9633f8947dd4e6c29eb3f782"
    sha256 cellar: :any,                 arm64_sonoma:  "5ac02f0a4152a06f2eee77d0f1ad3f05dd122e1c5ba978bc543fb54b25bd7ef4"
    sha256 cellar: :any,                 sonoma:        "bedbf8a188b8d48bd7345f0df3918e83cec02a37034d206d269d074609df2a81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4708401f5c33fc127dcb9d037ac54b07e193e002e3945c1ec9de32d111f1c627"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8007a78659cc75c88bcd9b5b06778e910029804b560161cd93c5a84210b85213"
  end

  depends_on "cmake" => :build

  # Fix test code to compile correctly, remove in next release
  # Issue ref: https://github.com/microsoft/mimalloc/issues/1194
  patch do
    url "https://github.com/microsoft/mimalloc/commit/41faf0a45e31689371f49e5de82e85597eec4b92.patch?full_index=1"
    sha256 "557c259599c85bdddecb418076ea742ef4cef28f66e5917bc011a41c71fd8311"
  end

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