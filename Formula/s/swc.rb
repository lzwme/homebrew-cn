class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://ghfast.top/https://github.com/swc-project/swc/archive/refs/tags/v1.13.11.tar.gz"
  sha256 "0fcb23bf012ab1082bb5bcda76edb179a478e65f0f97af45c80876d96f71001c"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bf781f49bc59e68eb630ae8642f6d4c197938970a58d06bfed924f899062b8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "173e7326cc5a50a5fbb90647c4a470e1c39006c399da99e9c5132cb779c24577"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6fed8ce0ab6191c3cbbf172aa7470ce977725bf8d891f297b7b08ebad4a6e62"
    sha256 cellar: :any_skip_relocation, sonoma:        "c67276acf64dd17b22a73effcd9c7297265b7c501b3c5aacd7bd0dc74cdab4f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6eee0a0bcf1ab77d8a2941c49569cf5291dec7f5072de84499f87c62dfcf992"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77c3b200ea4ac29e05205a9fef7f50213c8a7fd074788b248021c494d4343226"
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