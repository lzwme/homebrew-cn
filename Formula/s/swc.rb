class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://ghfast.top/https://github.com/swc-project/swc/archive/refs/tags/v1.13.21.tar.gz"
  sha256 "bd1d890904cf3d99d36b8bef1affd6fc4d91a1b9ff6a79e57d43f2cbc0e6f176"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "894bc395de5f25faab318f965cc50ac60aabcdac28e6029661003e2e42b41de0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bff0ae9f3584fca3ec63366048de397d6b9f7be7ccc0e441f133a13b03a251cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f4978e59a4b8d17a3ac182b1b969e7c641cf535e3a42974823c97abc1890f1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "61661c98320ee7e9663bb8903110ecd2d1b4ef135e188df72a6c43fb52beb596"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d12cb70ef7aa96f97b48800faa388a73efe08a3ed252a4adffb5d6c2f06639b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1606ece4dfef34ff5d3b2d469c6911961ed4329abb891e5117f3db09a5358c90"
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