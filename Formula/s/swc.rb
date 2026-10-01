class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://ghfast.top/https://github.com/swc-project/swc/archive/refs/tags/v1.16.13.tar.gz"
  sha256 "c72826492d1f4613c69792af1a9ba9352f1cc8e7e92af33f1e9f352b322eb291"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2b5a3802be7a9a0a93cebeb336d5736614f34d41c1ea7eff6e0a389c179e5a7f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ffdd52767b36e265b163900efcbe27d758082b22942b84537a08e0be2fee8b92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c06209b590f79e546b2ecd82ce7998a2a80a0c72813df27f7bdbd3d25f6ec45e"
    sha256 cellar: :any,                 arm64_linux:       "83804866d92ff98da323b596fb169c9365a38201cd9099dd890dfa60b95ec8b1"
    sha256 cellar: :any,                 x86_64_linux:      "e7e02593a058b5f43124f57110b03034f8b1d684d020f1b35bd8a4a0d8f6d9f5"
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