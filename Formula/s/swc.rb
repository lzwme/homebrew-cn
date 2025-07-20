class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://ghfast.top/https://github.com/swc-project/swc/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "9ce62201d1b5da4fd5796b998eca3efe2669b22d7828e3107fd5cb1d5b8d36e4"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "689a1fc5048d2f96fee4bdba31c9634a427f1530475718e0837d73953817c1e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f24d7c4e493174d16d010888a2645f82086f65c970b27896eaf407a1a715ca9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "45b3a7c9ad0075e77f272455d312c19e284ffd3e29b597708e428a6de6029d8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6deef3394ced492958365fe59dcb560cdff7dc8798a87255a940b7bab59b787a"
    sha256 cellar: :any_skip_relocation, ventura:       "bf48354996ed4628dc31bfa7dc80baa73e6fcb76fab6a0ae4740bd883596644e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f6e5b21eed149db20e3a1e395fb4b1e0c34d2405342ff041b1392b380992a16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dfec30d2828268d94183ba51b974a84d2e73ff59866136725ed1e9a3c5ca9f7"
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