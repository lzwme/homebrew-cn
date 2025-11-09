class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://ghfast.top/https://github.com/swc-project/swc/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "4d37d2222ae7864afa0c3a88cba6e0c2a92d319787709407ffa8dc4f70eebb80"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4beecf9debdcf2b635e0223b1bb5ac18648fe3b9a2857ff0a32c872c883e970f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23c37e9a3ef3448e701e99a40b9a686e90b394df998fcb8359623f7370657fd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39d239f4f21496b84927f70b46695382f3f2d004d2e17abe74847de86035cc76"
    sha256 cellar: :any_skip_relocation, sonoma:        "371292c79e1c7dd10c86c53fea6a8770ba5283b777906ab81bb8a64522bb0ed7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e3c4a1005a05f822e7b9807c103bc5e9f69ab6af9d2bf5fc9ec894b64f32d60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a849bdb61a5a59e47bbaf4a598305e9499c57a5bf73af591d62c3ff062f8cd7"
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