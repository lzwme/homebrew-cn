class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.25.tar.gz"
  sha256 "eeaacac16097613d0ff237045d4ee5fc2abe3b1decfe14dfc37a8cfd49ce2aeb"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3dca15f1e8a5d0a29cf98c356db1c949cfe6740d5e6d4f7308633948b84c539"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d204c661c1c6b4516ce7ff2be532b18bd89e3c1b9dd1f17a7e69c904ac88a5ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42a8d70eee34e120af5e5c4e0473c57f8387817c5137195be450ba7ceb168786"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9c41d91be24786bcde9baa330a95dd7c1ae388556277d272c87bed0de87ede5"
    sha256 cellar: :any,                 arm64_linux:   "b976103aee058871b6e97d83d16bc77e386da3c6bc8b6a6ecd561862f5f8c091"
    sha256 cellar: :any,                 x86_64_linux:  "18661680dbfcdd1108137cc60f0231c164787064e4a10c1a14e29ce4f2b07933"
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