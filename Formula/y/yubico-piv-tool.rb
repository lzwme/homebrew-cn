class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey PIV application"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-2.6.0.tar.gz"
  sha256 "80f4b7b7f5a85c86502f3286e2b4bef345a6709f4554088c745994f7027302c1"
  license "BSD-2-Clause"

  livecheck do
    url "https://developers.yubico.com/yubico-piv-tool/Releases/"
    regex(/href=.*?yubico-piv-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "ad91a84ad0b292b36f6b45679b6e31f9e498f44723ad0ae68b057494b45b8b28"
    sha256 cellar: :any,                 arm64_sonoma:   "ebe0a537fdad1083258d6d6e24f3c4a432e32f866c82f4cd1828551c64c526d1"
    sha256 cellar: :any,                 arm64_ventura:  "96c67a93b88fe4b8599c5382c43d93fc75adac113266b8f0cedbd6863fa83c51"
    sha256 cellar: :any,                 arm64_monterey: "e11fef559f07c9c4e8b2e9b7db016edb88848d90fa0247fe35545d8bd3457dbd"
    sha256 cellar: :any,                 sonoma:         "65774cacf1cc7d1ab6e0b8ed3c19ebb0feacbd6aa9bf426706bc478e70b29453"
    sha256 cellar: :any,                 ventura:        "2a61b2aff37264f0f2a8d14c7e5874c5e823c70f1df60a41eea50c4b1b8fc46d"
    sha256 cellar: :any,                 monterey:       "bd36502b3e87fbcf978691aaf923095a2d492e51d878b48449f7fc2f3dd25830"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee448d6cedd87948f0eda339ce8ec1616c9e3583f42cb6b6c80f04dc636cc4d5"
  end

  depends_on "check" => :build
  depends_on "cmake" => :build
  depends_on "gengetopt" => :build
  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  uses_from_macos "pcsc-lite"
  uses_from_macos "zlib"

  def install
    ENV.append_to_cflags "-I#{Formula["pcsc-lite"].opt_include}/PCSC" unless OS.mac?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "yubico-piv-tool #{version}", shell_output("#{bin}/yubico-piv-tool --version")
  end
end