class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.29.0.tar.gz"
  sha256 "bed1302e23c058193865382f4fef8e86764e96682ded86e80d3624ceb48acfc9"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f0ee8b6b24c55b4d2f9027a7a18df0f5cda887d3e39cce5ece4168681bb6b90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "828e0cabf65e6806a861ad80dabaacc940e5f690c7577f2a6d717a98894d2459"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8152b64c0c7ba406e145404213aa269a904ce99f73495b5a4304c4508304c15f"
    sha256 cellar: :any_skip_relocation, ventura:        "415d03cf7750adee3bf6413a047a234ecbf8fe0d5cf7093076644128f76184b6"
    sha256 cellar: :any_skip_relocation, monterey:       "1f8e856ca5fe371889e6a4a81c064b128f3803d12148aada20b5cf178c882bd2"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e5813f21bb2694e0101bbe12def4c7840f9c3a4d643618abb582d55add72301"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8926ebf527088769064322ce4fadc94cca66c99a6d440e65d78170563d24c075"
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