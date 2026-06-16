class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.17.tar.gz"
  sha256 "d1570f92933f0ec11e2bd739c6cd7ff2db83309585315027d61e1e6db934d59c"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8333c6aa8dfd206e241618210dfd11fd6c94d423c1063f810738235a8c91326b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d847b7d049980ae3dcc512d31a5cc02926c79a550903d529d5f8b4c26e625653"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8f8fd47b565e3b1977f86b89999c0b8476ecb1bfdf4a40d7d65b7cdcde359be"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fa266eb6f294a2961a38b773f63c185a1533a9e47ad0c6f1ca143c4b5e3b3d8"
    sha256 cellar: :any,                 arm64_linux:   "97d7cb372ad316f533c2a1fcf73cc289a677f79b0b18cd77d04d098aad44609e"
    sha256 cellar: :any,                 x86_64_linux:  "8270e733462b8ce67413b3a85265017383f0d4fb4c644747fa78e489435428e7"
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