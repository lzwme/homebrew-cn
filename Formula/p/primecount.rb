class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  url "https://ghfast.top/https://github.com/kimwalisch/primecount/archive/refs/tags/v8.8.tar.gz"
  sha256 "9e2a3a779d5a274607cc40119544317b5eb41761b84cebb348d5af7d75d073b6"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "78edcc1ccddbdfe3f6b064cd9ded9ef75ec162c9f71198e855e1a8d1a8bd6ed5"
    sha256 cellar: :any, arm64_tahoe:       "db12c37f96d38ae627be06749bc29e942d80db560e6d02b9bb5723e3294224de"
    sha256 cellar: :any, arm64_sequoia:     "665974a1a2959769ea1886a3d16529c9466bf4d67f798e1b61a8f8cc9e960c5e"
    sha256 cellar: :any, arm64_linux:       "011341d4a9509a8e55f96d71eca0cac41c8eab13f0f052b30c6c9b43308be4db"
    sha256 cellar: :any, x86_64_linux:      "953dc7774ad112badaaa429b359eab08a0708cbf9412f8645c92c52da8698a41"
  end

  depends_on "cmake" => :build
  depends_on "primesieve"

  on_macos do
    depends_on "libomp"
  end

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON",
                                              "-DBUILD_LIBPRIMESIEVE=OFF",
                                              "-DCMAKE_INSTALL_RPATH=#{rpath}",
                                              *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal "37607912018\n", shell_output("#{bin}/primecount 1e12")
  end
end