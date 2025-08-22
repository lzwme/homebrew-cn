class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://ghfast.top/https://github.com/swc-project/swc/archive/refs/tags/v1.13.4.tar.gz"
  sha256 "7beed49a107d5eb51f06b365407957d74f6a4ad1d021d5b4bc178c2ab4d92522"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26d24c3f76cddb8816d37d7ada480c7591b5ea7154609b7c03ca8a0477e66e6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70559a0cace0066165f0e9e5fb3e51699575175dfa380e19ae5e1b788c45c5e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6eec8bf8f2131dafee1076dfbf60146d6f73346bee488f86fbc31ea1a57aa0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a23ee461cec68b1d4dacd0af3a73776f2839e663d7e47d7557a9b3ee29beebb3"
    sha256 cellar: :any_skip_relocation, ventura:       "6ec3f04ea7c3f3e9c1162008fd4f8015c074381ed1e0ec2e354d5d6e4d960ae4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "158a82ca6a3234751b30c0e1429ed99bcaafcc6f0364435db0cf55e8a671a6f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "381273b5b4e89ad61710c0938e1086a6d98d59e6b566f8d39e38c23d3a5a1cf3"
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