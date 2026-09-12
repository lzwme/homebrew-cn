class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.73.tar.gz"
  sha256 "69ffb6abe34d0667c38d4abc49abd41fbb7b0ba23890552a3e982840f9331faa"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6921fccd330f9bc7827676349dbd4b452fd78f5bdc8a0386abc95efee2701c3d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "70919a05a881685fdcf6b7c5c8567a0ea397403dd7026ea43ed27f92007b274f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9a7f1089133dbb1d9b4e747a61a715e657809e1ed654f50e4620f100f1ce3f36"
    sha256 cellar: :any,                 arm64_linux:       "e9f5b62fe8296da4f1d77a06b07a7c7ad78477c25382831f09409003ce421ef9"
    sha256 cellar: :any,                 x86_64_linux:      "1349b9597da65d0f7da11378af0846e702070b2c211c3e63aa8f0650921da937"
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