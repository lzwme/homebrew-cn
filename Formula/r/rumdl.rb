class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.43.tar.gz"
  sha256 "dbfdc5d23756d9b67f328a676aa21b2828f895b7c8aa4c230a5790e58ba73828"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d36c4e907017b9cfabd82d15d97583c6d8248510033e7ab9c8a7d762c55a827"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65a22e01c4fce6fe74afecfddd3d7495d9df46011cb8c06411a96c23748d75ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4af3aa4b70cf652c6a19ed7a99713da6c5a57998c8dca8896a31a2a9fbe6e069"
    sha256 cellar: :any_skip_relocation, sonoma:        "d06994bca281c4eec69487bca459b455f4d4d1c91e5f3e981e3ac1c14052ce2c"
    sha256 cellar: :any,                 arm64_linux:   "1267252e3b3d2a429b61d8b09fddfde3864331b501a8a5f8e1e38659273ee825"
    sha256 cellar: :any,                 x86_64_linux:  "f35610c3e056880328b7c402df7cee20f1bec6901cb286c9d0ec14500e4e40c4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"rumdl", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rumdl version")

    (testpath/"test-bad.md").write <<~MARKDOWN
      # Header 1
      body
    MARKDOWN
    (testpath/"test-good.md").write <<~MARKDOWN
      # Header 1

      body
    MARKDOWN

    assert_match "Success", shell_output("#{bin}/rumdl check test-good.md")
    assert_match "MD022", shell_output("#{bin}/rumdl check test-bad.md 2>&1", 1)
    assert_match "Fixed", shell_output("#{bin}/rumdl fmt test-bad.md")
    assert_equal (testpath/"test-good.md").read, (testpath/"test-bad.md").read
  end
end