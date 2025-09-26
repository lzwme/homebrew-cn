class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://ghfast.top/https://github.com/swc-project/swc/archive/refs/tags/v1.13.19.tar.gz"
  sha256 "dd4b79a52a244b1258899139a309b19e8d75582fed1ba571bbff8494822e6f39"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f557f51fb4dc3c86771ac41c53fb702ebcc9afbeeb4d75cdfd2bd2fdb8a5587"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee02063677e39a05730c6571266f217536af7d414630c97df4ff1c7a94a41a13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4dc86f8d38d1af1654f5800428ca31412d4e217f8da2b07d2dc1d4f7eb7cd91"
    sha256 cellar: :any_skip_relocation, sonoma:        "53acde835714d6d40357cf82e53f14b11a43c9b84be8b4f71660af801fd97c26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d90a28a5c027864d6a44071b5ef43fea77252655aaa83793c7b042caeb38f1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fa2f592d8ad8cb7842bbff1f5348ac6e493fc27d148e2315b898acd4fd39562"
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