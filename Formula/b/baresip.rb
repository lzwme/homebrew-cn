class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://ghfast.top/https://github.com/baresip/baresip/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "4b9fba7c53cabec4cc702bf47fb421f078d6f31421b7bea8f3f0fdbe1a671674"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_tahoe:   "e78cde7fd04ff2c722a2d488f1bdeaeea26ddb5872db21b3c7820095632bbd61"
    sha256 arm64_sequoia: "049d6a85fe0ce5b446e0cd67867065f2527aa91bc9f85b268775b326ddacf789"
    sha256 arm64_sonoma:  "f57364b17d30bd865e800c47fbd720ff4159dc52f2ad7263c09fd629c31f91d4"
    sha256 sonoma:        "912c041a07671ea5657a6adbf9e8fdaa9562e887b17f5e982227274a0b024b69"
    sha256 arm64_linux:   "9385aeebebba702ca7f8c39989ccfba4e5ca926b72a548a2f3dc697b002ddc4e"
    sha256 x86_64_linux:  "d8427ec7146e4415a8253a9d3b3cc3ed069d3db013a0659c439e1584c9a7c8d3"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libre"

  on_macos do
    depends_on "openssl@3"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DRE_INCLUDE_DIR=#{Formula["libre"].opt_include}/re
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"baresip", "-f", testpath/".baresip", "-t", "5"
  end
end