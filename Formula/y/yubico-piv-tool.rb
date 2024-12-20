class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey PIV application"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-2.7.0.tar.gz"
  sha256 "778f6de9eb00f99d042a573220395ab29d45c0d1018a0dd619c17783b2da712a"
  license "BSD-2-Clause"

  livecheck do
    url "https://developers.yubico.com/yubico-piv-tool/Releases/"
    regex(/href=.*?yubico-piv-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "51ea4e319880536e344a8d3b2dfbb04b4f1e01de11210cdab88564bc74ee1b17"
    sha256 cellar: :any,                 arm64_sonoma:  "16ff1cbed244780f03c308a554468629683ec83d7d611a58208b19cc9349d1ad"
    sha256 cellar: :any,                 arm64_ventura: "184c31dc89c0888650fa8da2f41327e71fd73147eb5598dcb24b556248177d4a"
    sha256 cellar: :any,                 sonoma:        "b53064f660733a3d57b6df54f9040929074a86a36cfe5bfa64bdbcfb275d71df"
    sha256 cellar: :any,                 ventura:       "44b3d4191563e05e138415d20e40db7c63a3a6238faf75bdef9dd2c1ca9d3cb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2224ac3842df368843a5ee263af30ec3453aa6be116a15ecd1659c9cda44ef4f"
  end

  depends_on "check" => :build
  depends_on "cmake" => :build
  depends_on "gengetopt" => :build
  depends_on "help2man" => :build
  depends_on "pkgconf" => :build
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