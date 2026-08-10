class NextpnrIce40 < Formula
  desc "Portable FPGA place and route tool for Lattice iCE40"
  homepage "https://github.com/YosysHQ/nextpnr"
  url "https://ghfast.top/https://github.com/YosysHQ/nextpnr/archive/refs/tags/nextpnr-0.11.tar.gz"
  sha256 "feb39c421cd432b3ecca004a6fdf0b7578375a7f12401906dd27c25eb948cdc3"
  license "ISC"
  head "https://github.com/YosysHQ/nextpnr.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ff780eeaef569fe6521ad141f7a27d56ef76a62e775e685771c59dbabdf8ff8b"
    sha256 cellar: :any, arm64_sequoia: "6a277ea7b8678f8524aa43f835e7f7b1c2902c96d2c9a38191cf8cf200a90609"
    sha256 cellar: :any, arm64_sonoma:  "a1413efe21ccbfa48948df3e20c8d33f4e386067a465a6b5f02f610dbbb83674"
    sha256 cellar: :any, sonoma:        "2a24d363c32cd11d267fb95889858ae46009ab2a74405d6a5fadb61d8c70381a"
    sha256 cellar: :any, arm64_linux:   "98ebcf1a3112fd18c0530c252fbf95084f2a0106015a4ec1a88151185e68ef8f"
    sha256 cellar: :any, x86_64_linux:  "13248d0a201ba7f9d518c681a8953bf82b18c88cec580f7d828f32f8f7bc984a"
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