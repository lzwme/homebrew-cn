class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://ghfast.top/https://github.com/swc-project/swc/archive/refs/tags/v1.15.47.tar.gz"
  sha256 "a5471616d4648019865150b29f0b1c46755441777fd4d13a119c6dca1398e294"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dec9ee3688e5739ac1d979474b68094f68164bb81d6153a0cc75321d69c24dd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1dcb9adcdb29af94ce5598ebf77abfd54c094779f50a744df314f36fc554d911"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b5b1b588160d90a9c23e6bece6d0ff27eba81d85e40157e8e577291949237f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ef0e0c4dffe208f59cea37f20b80de8f2569658c4952ab58952931e5852e4b8"
    sha256 cellar: :any,                 arm64_linux:   "b56330de288232e5a6e70ab29b927719b7664f5660083483e744bdb902970c0a"
    sha256 cellar: :any,                 x86_64_linux:  "a80238a0e980a5782cf45c32dca34f8f652b00deae124ca6234c4c80768d8190"
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