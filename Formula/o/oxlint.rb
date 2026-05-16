class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.65.0.tar.gz"
  sha256 "7009ebd473e030690276c2006f007b69b762687d965c34b97c8e6364c4ce3f7e"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4af7c1885ffba00a0f160aed277ac28291f8a6ce37f2a35ae1f22139eb3fcb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c65c9f864cfe6a9ebc76673fb6b167efb3ff3aaca068c7210067cf8fd2b399c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "218224cf829eabf9985c9bc72f43f475d63daaa31b00a3ee6373a75c51dde34a"
    sha256 cellar: :any_skip_relocation, sonoma:        "35b49a3157afd7b4f7a3d2569f355add32961c5e36d42d5396700d2cced1f463"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11c3c0ae82fe196a053459df7fd32afcaf25d6e44bb3e1cac538550fe75e39a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21b1729deac06de629bde3d95396e5d614f0de9e0c98de5a4c25fa083006ca6c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars)::Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end