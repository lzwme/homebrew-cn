class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://ghfast.top/https://github.com/baresip/baresip/archive/refs/tags/v3.23.0.tar.gz"
  sha256 "7b2689061e6eaed6ba5d659d0dba830603c44a7160c90b913d437678ae544b5f"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sequoia: "c88b06259a3fc929603b48675ba8ce259a9a2629426c34a4ede978f11d934ab6"
    sha256 arm64_sonoma:  "a37f29d586e05837d53b16c7a69c8b56f755cd8f7249d37a1db91ad655fb5ecc"
    sha256 arm64_ventura: "0968aa6f3ab07833e9d2da186ea60ef470a94bfff04f5a8c1014782435fddae3"
    sha256 sonoma:        "6512f922d28667ca4cbafd3f900eade03f1cb0874017943ccda3e1ab09eb2cb0"
    sha256 ventura:       "9fe5ecb44330b7fe0a619a9ddbaf3bc8d8ad02ceedcfb1f51f51a60ee3f9ef8b"
    sha256 arm64_linux:   "8b4e71d8919bebd3f9cc76ea31b0b24227aeabd7704d39d6b6b3af336f0141b9"
    sha256 x86_64_linux:  "af93e3b9dcee3fb6f8dd33038a507b2641d6bb024ad996e1e7c614618514e67a"
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