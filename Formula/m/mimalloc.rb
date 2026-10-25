class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https://github.com/microsoft/mimalloc"
  url "https://ghfast.top/https://github.com/microsoft/mimalloc/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "c663101ba193b5b823c8541c1b719ab67e3ebf9976e425a02359a5cad5e52990"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f0ca9b14c37a2f8621838dc795058adc231ae41d5ac50ff61c51cade91e5608e"
    sha256 cellar: :any, arm64_tahoe:       "c9075ee80c1a444d06222e93ad5ea741cfb393ac65d94e5dc102a6b88f2f18e3"
    sha256 cellar: :any, arm64_sequoia:     "0151d8818cb7134a075da6f2d1f7638d4c02408c9bfa28b51cc2fbd3c2a3711e"
    sha256 cellar: :any, arm64_linux:       "d89efb7c27844692356c70644f4d064229b621d7a64c726631e878c0a97474be"
    sha256 cellar: :any, x86_64_linux:      "5ba33d5e07a12f2c51dcb43667feb05641b1657ecc0ab129a20391d74a6ea245"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", "-DMI_INSTALL_TOPLEVEL=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test"
  end

  test do
    cp pkgshare/"test/main.c", testpath
    system ENV.cc, "main.c", "-L#{lib}", "-lmimalloc", "-o", "test"
    assert_match(/blocks\s+peak\s+total\s+current\s+block\s+total/, shell_output("./test 2>&1"))
  end
end