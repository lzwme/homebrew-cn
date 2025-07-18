class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://ghfast.top/https://github.com/swc-project/swc/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "92ec85cecb9a45594f1f38561a8580495a26bb7d73bdad66d041bf860bf486cf"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dcc26d2c21647aa20af08fa67936ac1b4d042be0b20e1601e5866468ac8040f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a50a8585360a71f98796b2f2fc56a82f84316bfc95fd3d2e2cd2a3e43f7dd62"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa3944408bee2384cfc52f3fe07763dfd6233bcdfc4353d038a217f914fd6d37"
    sha256 cellar: :any_skip_relocation, sonoma:        "e71b551e49aa991613b14cee3ae88facc3465142c8f155762de673e2391dd30f"
    sha256 cellar: :any_skip_relocation, ventura:       "3a3112324eb106a4db157ae7487b55c56daa92190fc567651373a4242c456fdc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cc226495486fa364bebe15ffc510e0e9358f442daa584271e2602f4056b2ae0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "960f3d745effbb50eb1dbd662c9071deeb2709e8ecd6db7b31a8f6a4a68e890d"
  end

  depends_on "rust" => :build

  def install
    # `-Zshare-generics=y` flag is only supported on nightly Rust
    rm ".cargo/config.toml"

    system "cargo", "install", *std_cargo_args(path: "crates/swc_cli_impl")
  end

  test do
    (testpath/"test.js").write <<~JS
      const x = () => 42;
    JS

    system bin/"swc", "compile", "test.js", "--out-file", "test.out.js"
    assert_path_exists testpath/"test.out.js"

    output = shell_output("#{bin}/swc lint 2>&1", 101)
    assert_match "Lint command is not yet implemented", output
  end
end