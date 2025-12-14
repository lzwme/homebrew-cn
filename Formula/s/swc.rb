class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://ghfast.top/https://github.com/swc-project/swc/archive/refs/tags/v1.15.4.tar.gz"
  sha256 "8eb1a46eeceb675fc5269051a1a9f726d3720e530f3d14b7f2057120a12ef6c7"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55125e82d6f98f57764ace429b9ca0df475a64fb603e60c2fddc746ceb778b1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c97dd5650b3ff21012f07fafb8257df4953d1f6eebb691656a3938a7b3bdf777"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbe266caaed38e84bb1609c448028ae4a7049b5c233b832c343b275f34c99329"
    sha256 cellar: :any_skip_relocation, sonoma:        "1267865fad369db1ade9b056c6f9bd8a67105544d50f4229b0bc65b70da29515"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "427d06728fa4db6bc0726f434536de59b868c2c498a4e4cd96f8cf4bf3c3ba13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2b6a8804695766ba5e1dee2e22292e02e6ebb126fcb91cba39aacc8ed1383fc"
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