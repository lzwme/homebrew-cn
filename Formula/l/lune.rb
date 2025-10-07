class Lune < Formula
  desc "Standalone Luau script runtime"
  homepage "https://lune-org.github.io/docs"
  url "https://ghfast.top/https://github.com/lune-org/lune/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "e9a58cbe1d888cc4e9a119fea30340acc8fa44c197f11c065393ae9fb5480395"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4aa1edec4a0ec35e04d2fa7fcec729307803c695d821727e9ebe1bf8eb0f7093"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6514bbd57baa6ea6ae80bae06b25c1b937b619172d6560fab2e3fa0c3628e6a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "364ab8d17fa20b91ce0c3f9cc820fc4c359e1b34fa1f152fcc14c473f8462cbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9a787e12bf1e5ccc93208eb349edcb5b8e431a95366f7ee6bc5ded3db54e94c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bedd165c6ee425ec310e58c33cf0843143d7638a1f1a3aab3d588fde852e5a03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35f028b2ae04e5dd1892aef68d756e3ce8a10b859dbc92e99e4779341c433f99"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--all-features", *std_cargo_args(path: "crates/lune")
  end

  test do
    (testpath/"test.lua").write("print(2 + 2)")
    assert_equal "4", shell_output("#{bin}/lune run test.lua").chomp
  end
end