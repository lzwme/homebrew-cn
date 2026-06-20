class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.20.tar.gz"
  sha256 "d0a5a110dc2c1fc153d3bdd6624886dc08cd33ed0094eee6c2bef896ace99e59"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48e61a1c60215f358ef5b91f609a1b8e334ee71dab07cd4d4f8946200bf5eacc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "710f96ade96df87dd915f786034b2c8f4ba7b7718b0ceceaef176cff5155b76c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d35b39d5ec5eaba922f135d9589533db23efc1dd63ee030fe1cab89b80ff217"
    sha256 cellar: :any_skip_relocation, sonoma:        "f890364c81a135c3891b861469f0fa226d3747be27149bbd14f3f1f6dd91a541"
    sha256 cellar: :any,                 arm64_linux:   "2c7a89080e8f8500543651dfc6f71ca135bb2785b43988e0cbf2756c20e154fb"
    sha256 cellar: :any,                 x86_64_linux:  "f3343725fb01f8638e82b2037b5f203673d856ba4f0bc36922fc898120fb39d6"
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