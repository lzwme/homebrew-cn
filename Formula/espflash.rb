class Espflash < Formula
  desc "Serial flasher utility for Espressif SoCs and modules based on esptool.py"
  homepage "https://github.com/esp-rs/espflash"
  url "https://ghproxy.com/https://github.com/esp-rs/espflash/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "01b65bdd7c22b422d18db6cf186cb788151f0ca0eda9533ff9478aaf7255a2cf"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f44264e11af010ce8ece46a0d10b1878029e073f1bde378837b601f6e8663d73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d87b75a7a6e34b8b77169dd7d2750f3867375424766e72f6f1ff1b10d56cb3d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15e0c693367d583006dabc6cdf031c5a0bbaa64603e8d927cb434e9203909773"
    sha256 cellar: :any_skip_relocation, ventura:        "2a4c6c761f111620f6583194d563955e6dd99d3be8bb3d85cf88e68e8c866d91"
    sha256 cellar: :any_skip_relocation, monterey:       "c0faf6c60c9874689defaab3d1efc5f03b2cc5330c160fb5b97daf9ea0717342"
    sha256 cellar: :any_skip_relocation, big_sur:        "2da5ad616783a6470878bc156d6cd55c1beae4cd8e5fc3bea903a71d682aee2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fb46cc63bb1af5086ca02c1a8c3278a6d626f4838840f7e36589b175312f66e"
  end

  depends_on "rust" => :build

  on_macos do
    depends_on "libuv" => :build
  end

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "systemd" # for libudev
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "espflash")
  end

  test do
    stable.stage testpath
    output = shell_output("#{bin}/espflash flash espflash/tests/resources/esp32_hal_blinky --port COMX 2>&1", 1)
    assert_match "espflash::connection_failed", output

    assert_match version.to_s, shell_output("#{bin}/espflash --version")
    assert_match "A command-line tool for flashing Espressif devices", shell_output("#{bin}/espflash --help")
  end
end