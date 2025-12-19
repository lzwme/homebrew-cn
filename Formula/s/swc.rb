class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://ghfast.top/https://github.com/swc-project/swc/archive/refs/tags/v1.15.7.tar.gz"
  sha256 "2a76299a9a26aba5cc167f331d8990e6de0c15c18fb6f6bcefafd6a2792df650"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "132fb898e09fe5e8f3d5886f2b8815e06ed9d60ed4de1e994d750e2084cfcda1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd8afe12f6713fda3292b379b6ea3649880675e6185bf435f5b925256cc01453"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "663ede84d01c4d2f3b6189e4b1c73017846bc4b2dceac16d381e91d1ec2fca74"
    sha256 cellar: :any_skip_relocation, sonoma:        "83b34ac8db8c61b03108c7141b78f04414ce9e47384c97777a6b79cbd47f5955"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "332cab25e0d577c3a622e392f880ca8dda9dc432492fa295d3f55dcb6a8d0477"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e39e735c21541c23347b87f70d42e589c531160210a24f5f180e94fa506c7c0"
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