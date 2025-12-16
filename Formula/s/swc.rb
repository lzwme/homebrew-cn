class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://ghfast.top/https://github.com/swc-project/swc/archive/refs/tags/v1.15.5.tar.gz"
  sha256 "b545dc134058f37c0bd9bb43dcbce21b975a53cac756117062204d8a55c5a9af"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6b0276611a9473220dc708b29ee5764bf29b15c8128bd55c9bb61858a96bae6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6471fd6df8ce7598244709834b249cce5e5a22d22f7a9b495c6f868eae92ac0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "019e8b19e46714a0affd0605b34a045f70fe148323153b574cde3b1b2adf2b30"
    sha256 cellar: :any_skip_relocation, sonoma:        "da6fa97907070c33268ef7cc007ba5aba3d1410bd941e29ac95147312f329493"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b74e70f1987813f8335c6e664aa165e601697fce32b263d5f50edf688bfaa02c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd6cf6d893a954e6aedaeb97bcbfcb4cc89a35e900acbbf29c0c64cd283c81f3"
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