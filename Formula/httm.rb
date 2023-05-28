class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.27.0.tar.gz"
  sha256 "7d2aa89903c3d463170bf9168c38b1e5ba3ec74d48684f57622090f31a9ef7eb"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48f43543962ca91d5dbfd04d4b0856a063877121c2feadcc479e992778f6930c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "671b87e02b0fd4097f5265cb8c27c5dc7ffee685079bc5f32b7966325946c4cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "407c118faad3a298ba9f7008e0ce5f9ba8d2fdf8d23c85709e631541698c56cf"
    sha256 cellar: :any_skip_relocation, ventura:        "3fd7818b9aa6d9f376fecaa420f53ea88bb31f361ba4c2497153c3ea8a79b73f"
    sha256 cellar: :any_skip_relocation, monterey:       "3a79a32af413b9aef48fe3a8d35313391bb1fdaf381c886f21e08d217e3b6edf"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d0939c25569d5aa65f6790d3b4f31a645fd4d40da440317eb73384d5c6f9333"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "703ab78b94ca79d8011a53f0dccaf06a9c1c8d805b52ba233461c8146bfe1e63"
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