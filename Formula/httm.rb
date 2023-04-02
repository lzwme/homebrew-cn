class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.25.8.tar.gz"
  sha256 "397c953eb0a8e1345040feaf69fd11c9897fb66071fc6e78c8cb9b8352e0deb4"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23b5b778419f6ca0f016f245f879847a570a1ea44fcfee5eb0463733e3b3de98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e12337d0f6651141ebf65583675770769a8f693bfaaa5f668ce2db4ad7320d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "795426366d9224aaadee3a9984e15cbae1d14a823a43d79348ab97f322d035e0"
    sha256 cellar: :any_skip_relocation, ventura:        "4215d9a72aba6b667652272b011fc38a230a1020a7de425b44eaa13eadf49e87"
    sha256 cellar: :any_skip_relocation, monterey:       "2458ed5353c0766672062090d6bc1534f54c97729c8a0ce98aefb608df3e5fe5"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d965b684a9fa5cce9700f76e9d6f30f5bdaf46f74b4a42d2934e7475d7b8623"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0ec2c8b191adc2a756247ee16aef73d35741a6507aa9ccf8162fe7575dd5cfe"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end