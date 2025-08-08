class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.11.0.tar.gz"
  sha256 "5cd3a2ccccbd90a6d5029ebd6a59452d5fe1cdf1b5fed88d91b971c32079fc2b"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4c7d24545b00419b012e8d3a720f920b1c3c253a207a3e4394ac0ea4b01f096"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6e4efd6e4d6d4f97eecd1ea2a28821df34dd6f876313414def47066eda8c6c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a244d5cd3d280e115cf756076f5c9105f8caa245ca841ee646e70b5d5f19480e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a3769039946eed8ac6eb0cd715f8b440d7a1ac63a81789140e136072653ded7"
    sha256 cellar: :any_skip_relocation, ventura:       "386889612f2d89eeef3a95ba6aaa501debae192935def76c3150e02995e5a6f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36ed93f1e83839bda344cb4a1a0c7c531c4142525420784fa7f89f38d8810327"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be5f8e44a2ddffa1effaf1c96b131b918fcaffc4dcaa99e9d99fa96c6e9ec90c"
  end

  depends_on "rust" => :build

  def install
    ENV["OXC_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end