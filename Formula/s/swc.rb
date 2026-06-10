class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://ghfast.top/https://github.com/swc-project/swc/archive/refs/tags/v1.15.41.tar.gz"
  sha256 "16c0aa0f002fe2854d8e907cfa84ef42631f51f32246542ba6176c803f35478c"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "001721f6bdb88a15c14829a9081c06fdfb779c3ae72eacf58711724db5c669cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98ff8c5ee58fc1c075fced342643d176545494f9043ce6e8b16721711be9fbc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0403b209ea3da709210cf4f29ea1cdf6cc4465d6ccfbff1f84a9d24da5cdb335"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6374f8253758c7ca8cb9f9ada4b57fa1575a9884ab9bf3a5e5298b980ffd35c"
    sha256 cellar: :any,                 arm64_linux:   "3f82749ce0ee961d050c4cd68c7e0d20e3834bdb76cf3c740360356649561f0b"
    sha256 cellar: :any,                 x86_64_linux:  "ee09dc56bd9b8b26d7268a13f4b562b6b4f8a93281a92b0d6f1931d101e3883f"
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