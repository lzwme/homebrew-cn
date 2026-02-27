class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://ghfast.top/https://github.com/swc-project/swc/archive/refs/tags/v1.15.17.tar.gz"
  sha256 "b0245649463e06c6f6b80fc18b19e333f230ef358af815a9275a642b6e6ab34f"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ac0a787bced113b65847abc9fb1dc12b7505c32e9d39e373f0240c8fd9b1f7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82a2e42399cefe4f07c0f2a337bf8db116ec44847efc912a12f74cf4316691ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d66564b89b46c95d384f301393e2d6d44e2f76778b9152885ad4cf00b1592a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "70728f21b318ab6d7cc76d1f4371e257bc8ef254c252f4ae18ca1641534626c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eccb072cb1488be2188a628dc5396f78b7e7d3439eb660f1f402a512c6ff4e88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfb643c73f8902dd671788fdff9a1119c1ee5af9249f42e67974aff04fb8676f"
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