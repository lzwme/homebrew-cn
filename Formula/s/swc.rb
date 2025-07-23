class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://ghfast.top/https://github.com/swc-project/swc/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "81182d53eeb13b746f9482f2eec06f11267fc17685f18c69e7cc39e66a3cdf89"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4768f84981bc0a21c622f9efad88eb617db2dc1ff6df8b83625d1baa7b8eff7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a653bb48cd601c558041f2968800ffe0d238199f3d110dbc22905f7451acd41"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a422d541384d8637f5dabaf8b339479328cdc5beaa7ee5e432c88fff5c3d919"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8a6d52575b3f489e4addcaf4c2100fc6861ab88f68eda859b0932d43c937bc4"
    sha256 cellar: :any_skip_relocation, ventura:       "95b298d8076aba203ca735814e361b6266e86c2b880547ddb69c94a6b5f0b1b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "502e3efd0943e266593e430ec957e0efc7b8e9fb618b1133272b78cec48c4e93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9837cc8f9cbcb968c1c2740a8ae19215e04d9d33a9acb669ebc89f4027a71e6c"
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