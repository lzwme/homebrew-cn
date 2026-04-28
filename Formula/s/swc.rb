class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://ghfast.top/https://github.com/swc-project/swc/archive/refs/tags/v1.15.32.tar.gz"
  sha256 "05d3c544efa4d4c2a71387eb5f0719dffb4a5f2d9f9f03f632b97656cca5ddcd"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c41ed3143db492878b1004c20368be0a38ab75634ea38ab1e20ac8d8e35a56a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c4106406eb0e701365cfe7b6454b5820f8a3fe5a8d3bcf964e429141f12a0af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb3ef7cb2683f7a57811c149be0c3a20a86c92c502776a40292bdc00de28884d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0d0c73a87eae27e73768aaf0d2c8c8a813348e8336b11224d14b505d4b2f5e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91e9582dbd5fcdbd85f33b8f21595cf90c8436abce143850eadcef86d618c224"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e869837ace81fe648ec8e63403c40ce9df00ebec1f0d74f2607c973bf5ea616e"
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