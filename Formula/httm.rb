class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.29.8.tar.gz"
  sha256 "70a3c2bfb9b350272c3c05f5a13e470892b3052e8fd33ee8eb02d18ae52f290e"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1da9651ca6f628be68281c61c317d73d2111b7ffd8ea513992b02af2f2086a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c6fc4918e2242834884a5a130c98820283a9227f94018590f1992f3e765421e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26aed5bb86565e03416787b674a826a7d48d83ff1baeed3b8fadce7dbd42c1c4"
    sha256 cellar: :any_skip_relocation, ventura:        "c2c7451d7aea049f49e5d0feb9e17d85a19da3010ade1eeaf4da458076c159ca"
    sha256 cellar: :any_skip_relocation, monterey:       "1b21fe5fcb0d4ce9d1c1cc649226888c1ad4a6f69780b69ded0f355d33b3a481"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8a7cbdb9492b9193ae48a87916d469ebccf08fa12f6ef52f2357ed0ce95d334"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f636371e04973bc974daf3ae4620a6d3a2d4c4e3276efc49b8777723922ec4c4"
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