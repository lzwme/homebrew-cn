class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://ghfast.top/https://github.com/swc-project/swc/archive/refs/tags/v1.15.26.tar.gz"
  sha256 "0906bdc6e68946047461425a1134f838bd8feac7e40408ad230c41599c4236a2"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "904ba1ec661ef569f047247d51148cdb14d2a7025799857405bdd3ca5af18936"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a27d3741f30b1d99d566bf21f7e08fe68f67af68050de5f349ffb66382db397d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3146e990cf021322c463efd271ef66808e7ba26b7c1ec9ba7dd7aa809e7f3d31"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cfb6322c8b78c742170f4688e8f15da4cac00492b8b546eb833487f5d5cabfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd88dfb8e04d5ca30c7bada552c1b2e5ff2702d3c90b27fd57a9b88612fba3a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17ef06c2f2a10c79183f25f828afcdbebe92e0091b019000458ab7a8186dd831"
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

    output = shell_output("#{bin}/swc lint 2>&1", 134)
    assert_match "Lint command is not yet implemented", output
  end
end