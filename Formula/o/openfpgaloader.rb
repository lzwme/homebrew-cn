class Openfpgaloader < Formula
  desc "Universal utility for programming FPGA"
  homepage "https://github.com/trabucayre/openFPGALoader"
  url "https://ghfast.top/https://github.com/trabucayre/openFPGALoader/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "d2d3da194e3e578ce81f1156f85c128eb6021b73b0c67bbeec9cd5d8bea35fda"
  license "Apache-2.0"
  head "https://github.com/trabucayre/openFPGALoader.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "7bfa075fb4fbff6421c6be6eb714613eb402a4040cebff4d709f69493ec82efa"
    sha256 arm64_sequoia: "2b37b904852bf42c43e4b1fcf8ba292dc15a8dd615e7aede0e8747821a498f03"
    sha256 arm64_sonoma:  "49685694df24981b85300297cbf88831103d4237a9679f9bf32a68481b0a55d9"
    sha256 sonoma:        "e1dd0d24d9d7f47d93b5bd20843d54bceb97430601562141d7f7756551d8818d"
    sha256 arm64_linux:   "e9c891487369d745cf65dfe717a1d809848d7d2dfbd495a27b0afc8e3ca54073"
    sha256 x86_64_linux:  "4dba81a1e8d8629758c4875b0ee6e4de06d42211861df82ddc07b3877d87d7dd"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libftdi"
  depends_on "libusb"

  on_linux do
    depends_on "systemd"
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    version_output = shell_output("#{bin}/openFPGALoader -V 2>&1")
    assert_match "openFPGALoader v#{version}", version_output

    error_output = shell_output("#{bin}/openFPGALoader --detect 2>&1 >/dev/null", 1)
    assert_includes error_output, "JTAG init failed"
  end
end