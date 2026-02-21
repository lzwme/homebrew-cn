class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.27.15.tar.gz"
  sha256 "ba105cd3e21b17e67740139affe4a61ca3d913f24a02739cf462d19f6978e85e"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09baa8557abb9229cce41782787b5a66c9989656596606c450aa515a41f46f31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d12d1ccce544f3d1eb6861324c89ea8ffbbee0fae9a94676b85068267181c4bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "918a64257cc6dbe05e238d284e08c4af10e40cc9ded69431a0d826c83d1c7aef"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d3ae9b9df185d907fadcfba930cd98973a2ea8c4795e2dcc7736872fbeda711"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a395d5f468df8903e654ffacfc23abfc974b21ef0e2f0e172ecee6c27603a08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9596600f3ad7ef302f2e4c79b51b4f83fc33a90f01bb64b1816905ac0b92c182"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features", "native-tls,rattler_config", "--no-default-features",
        *std_cargo_args(path: "crates/rattler_index")
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}/rattler-index --version").strip

    system bin/"rattler-index", "fs", "."
    assert_path_exists testpath/"noarch/repodata.json"
  end
end