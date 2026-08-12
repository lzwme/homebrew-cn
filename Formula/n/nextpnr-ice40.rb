class NextpnrIce40 < Formula
  desc "Portable FPGA place and route tool for Lattice iCE40"
  homepage "https://github.com/YosysHQ/nextpnr"
  url "https://ghfast.top/https://github.com/YosysHQ/nextpnr/archive/refs/tags/nextpnr-0.11.1.tar.gz"
  sha256 "2af682d94abf3f3e116f2fad36dc7db314fa93bfbb185e63619f2ec4f5fe40dc"
  license "ISC"
  head "https://github.com/YosysHQ/nextpnr.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f72cfb9a7f583c9072aded271abf4f3fe8143a6d47df13d7848028d42eedc2f8"
    sha256 cellar: :any, arm64_sequoia: "940feded7a9ea0122ae2932102c21c72aeadd3aab5a5bb4cc560ad520fb96256"
    sha256 cellar: :any, arm64_sonoma:  "2d19ce48c42a580b331d6c334ee63dad056c5766975ae1bdbb566e3de52d85e3"
    sha256 cellar: :any, sonoma:        "a93f9f6d0b94d344a78073b1949474d72fbdb9646b6b67ec433e2a950c73d165"
    sha256 cellar: :any, arm64_linux:   "5c21de7b896a1e8e9e89752f7f50710e4ace878a0fdf142b05750884dd8461f0"
    sha256 cellar: :any, x86_64_linux:  "7ce87bdac12cde51ddb91a869ede8654a9620c1081ecdf1a11c5b7977967e75f"
  end

  depends_on "cmake" => :build
  depends_on "yosys" => :test
  depends_on "boost"
  depends_on "eigen"
  depends_on "icestorm"
  depends_on "python@3.14"

  def install
    icestorm = Formula["icestorm"]
    args = %W[
      -DARCH=ice40
      -DICESTORM_INSTALL_PREFIX=#{icestorm.prefix}
      -DICEBOX_DATADIR=#{icestorm.pkgshare}/chipdb
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "ice40/examples"
  end

  test do
    yosys = formula_opt_bin("yosys")/"yosys"
    icepack = formula_opt_bin("icestorm")/"icepack"
    cp_r (pkgshare/"examples/blinky").children, testpath
    system yosys, "blinky.ys"
    system bin/"nextpnr-ice40", "--hx1k", "--package", "tq144", "--json", "blinky.json",
                                "--pcf", "blinky.pcf", "--asc", "blinky.asc"
    system icepack, "blinky.asc", "blinky.bin"
  end
end