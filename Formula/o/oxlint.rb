class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.47.0.tar.gz"
  sha256 "86bd0cc8f29df43901d0d908a02cbeb5df5cfe989031d42ee412c89e843c1254"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c78661f709fc9499c5abf341a1001404098411b771313c99e06a958ac76087d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6adc30d5c621c5671ff64c9d174079a5cc8ad08e526c7f3ec5bf9cd5a7b18e42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06f015c6c353bea955923b21dba39dd547210f3361e8e3ac19f751bfe6fc05c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "17bd5c63477a73cb90b40a3e382c806205ca630e25841a0bd63b9455c7d8e771"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8c7dc0eef3844926e69e06a53da34cfd39379be56eccf88fbc3f38ca85d0c5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18b04a7ee245a94587b47a988e0961a4a7e35941363849d44d8b4409b61c8593"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end