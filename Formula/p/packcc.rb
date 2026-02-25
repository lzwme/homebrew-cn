class Packcc < Formula
  desc "Parser generator for C"
  homepage "https://github.com/arithy/packcc"
  url "https://ghfast.top/https://github.com/arithy/packcc/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "6dc28154e04a5af6f1cfa89eb654cd4c691bbced75d2b2a5feb09c6e7d458ede"
  license "MIT"
  head "https://github.com/arithy/packcc.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "5a0b8081546ebc891881680469460587fe18fe82d4944f6308f187b6d672dc8b"
    sha256 arm64_sequoia: "61b42e61dbc2cda04bb7ca832d1f984052a3a82cbf15017bddccb3b28722ce7b"
    sha256 arm64_sonoma:  "668064191d76831155eee117191faa4ab1299bb896e3fac830ecf9f9c2eabdba"
    sha256 sonoma:        "5e0b79858e62c36cc8073deb46c73b4fcd72d3ae29e6e68aa5e8b4ba3c8b0126"
    sha256 arm64_linux:   "dab45b60bb8c17f1234c2050a1c4bd53955a7278612fd116bf5627cd5e81e7a0"
    sha256 x86_64_linux:  "c7cf28c0ae4f5ff529ee87dca10372ad67742882ec92a72207131a085688a6e0"
  end

  depends_on "cmake" => :build

  def install
    inreplace "src/packcc.c", "/usr/share/packcc/", "#{prefix}/"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/ast-calc.peg", testpath
    system bin/"packcc", "ast-calc.peg"
    system ENV.cc, "ast-calc.c", "-o", "ast-calc"
    output = pipe_output(testpath/"ast-calc", "1+2*3\n")
    assert_equal <<~EOS, output
      binary: "+"
        nullary: "1"
        binary: "*"
          nullary: "2"
          nullary: "3"
    EOS
  end
end