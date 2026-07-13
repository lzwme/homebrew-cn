class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.31.tar.gz"
  sha256 "c26476da16b8fa4f770fdb52665eb70c8861fc727233825fc85b13f28c50a30f"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "145483fa67c14f4b0a0cc88d25da0d74d4813725d7e4526cacae515ad6db64c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d83dccb74f4e26e607767c163f54e305e42b470a2ac4c3beec69503e1a4627ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8241e8f40969ca1726de3b3d096c8896ba7a7a6d3a4cd8ee2b0c867a1b8d022c"
    sha256 cellar: :any_skip_relocation, sonoma:        "08cc549aaed3c596ea0dea9221d764ccd2a324e2704c5f47846b0753c98c00c1"
    sha256 cellar: :any,                 arm64_linux:   "1000ffb75a681ad25e1fd216b519db8db6b6d889316ce13b722c3fb28ddfa059"
    sha256 cellar: :any,                 x86_64_linux:  "7ac9ebc8cb46691333206e5b0999fae465c6f2211f5497995280906238973bd1"
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