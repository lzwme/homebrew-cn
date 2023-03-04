class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.23.0.tar.gz"
  sha256 "8dfad3b0e668eb2db03b493a464969de9f7d52b4442c024551b58795d9489374"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf83e458d761399eb96145c08bf7333e1a9c5dfb91812ee02a7b1e63028a22af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d111dd7cf03534bc6eda1d79552491d1b315fd10128687f4fb9d58357f0e4c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8d7413c98a4a2f7dbb3b9bb907da605ec03811f42aacb9f557791e6ae27aa84"
    sha256 cellar: :any_skip_relocation, ventura:        "8b81510e6672e32d3c17e3edba6f9606ad5b97d60f016483ea90cb45f9980dbf"
    sha256 cellar: :any_skip_relocation, monterey:       "c505d06a3780c91a8dfad58dca27144aab0fce0802cf91f3926ec93695a98cb8"
    sha256 cellar: :any_skip_relocation, big_sur:        "24338b2f7215a66aadeb9e5faa9c70e6f90a0675dcd2cbbf53ccec06c31bc5fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d645167b34246804a38e1968f0c3ef59ee3c1c9332cbe00cf40274470f749bf9"
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