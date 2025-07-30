class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://ghfast.top/https://github.com/swc-project/swc/archive/refs/tags/v1.13.3.tar.gz"
  sha256 "51cdfef0f8c9cc6641b1cdd9734832906c4396758e567c3005ec5fd9f6e2c01c"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0d1b36842938e7234417024f489d9869b75e0988e1e534a44a3337a5f225b58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8c4cc14cc455a91768222268a03256c6db60cfb427efbea6840200ac0493505"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34c7677d9010a784229d163db845b45f9890798e117a6f56957d05c6531121a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "266f151c2d03b44229ec8dec42cc120ba4f3b54e24342de5089fa5e7e7db8609"
    sha256 cellar: :any_skip_relocation, ventura:       "de3c85fa8b006b6588230daa7e79155a4bd6a4648af554af342461496cad504c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a70cc994b726160f2dfb5888f886f44637191773e47766faf1e971be94eb7ddd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "586ffdacecec10899c873c0843be1a41b473b5a769abe8877c0f40ec09a6cc0f"
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