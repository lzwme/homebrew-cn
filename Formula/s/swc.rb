class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://ghfast.top/https://github.com/swc-project/swc/archive/refs/tags/v1.15.13.tar.gz"
  sha256 "e4adb323c5d8d8cb6def09e3a3077889c552f445174fe33dc679a7a48cb21231"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7684d5991e0399cd3485f6b1c1484e8434dfbb828094855e79d852522df1b9fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ded16797be260be1ff4706677916c635679d6b03b235f9ec60bfbf98179c8665"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c46f6f36151529a34434f25089204b3091312b673c567ca0e05f706e9ca1034"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a538c57b1eee15827bab2d52dd47b5c2b41aca5090ecf7cffc391cf829cef29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "945ed088b434910c6cc9b90ec8339fa385e9922431689a56ca55f2d126930137"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b16ebd4945b4d26b210309169cc1f2886896cf1b9dfc6ffff5b1d07f709b76bd"
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