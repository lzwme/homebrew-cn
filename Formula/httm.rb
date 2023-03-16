class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.24.0.tar.gz"
  sha256 "a469a68f0bbce66534f0ce716c582b5c839bfe7a25889a95c4ae96056b1c296f"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a7143b4b5f6189db6367e7dd243173124cf0dc9f79530b0a2ede7555b9db6fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5b94c69d28fc615f7bc0b00305c111a86f7a6fa7db2af17a7f32226f0ee700f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87f8b41515d9071cfa2573d38f55459933cdab26c14eb307c51311c0ca113117"
    sha256 cellar: :any_skip_relocation, ventura:        "e05bc1316261ce1302e2b6aa164dc1f20520521c5bbbbb34846c065c4232dd6c"
    sha256 cellar: :any_skip_relocation, monterey:       "6bcae37eca709d646aeba58dcdd601725b6c252ca76bd33d510bb9bb12728d2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e2a594a83f21eaef8dfb7c93a7d48551d6e1f4cedbec905f35c4eab427aef8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78807874282be1eba70c20034c8008fd7c3c805780fcabd4f906c36e9a5b4e9f"
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