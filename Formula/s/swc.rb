class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://ghfast.top/https://github.com/swc-project/swc/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "6dba1976ace0bd7abf9e5234aa09c2160c7f82e05672d9f85ba316cb04038127"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11e59118c866718c73a89e603ed686de890bb998484b3a4dfd0dc84fa0648d0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb2799984edf155228d7155ce4b66fc84d9d8cae77daece6823d1c57cba958bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b94c33c0f401d538178067edc9468e6424447de7cab9869ad1a0983fd3f88d64"
    sha256 cellar: :any_skip_relocation, sonoma:        "33e45d47b1346a5260fe307c31d0450e3e8ccbf3e44fbcca3e956c0bcf52c510"
    sha256 cellar: :any,                 arm64_linux:   "743cf12eb5074024be5869e428378f19f963231f30c38cc7051005a6442005a0"
    sha256 cellar: :any,                 x86_64_linux:  "e65b93ca93c0ed8b5e9948676db0bfa775a9a4a51c01e1a3c1970c0747efe268"
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