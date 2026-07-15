class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.34.tar.gz"
  sha256 "892ac4aacf39aac0b4d94612187b8b056c39af11aa576e915a6e870a17d8ec87"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b567dfaa893a1b541bad399dc174822a6aa782055097da02be94d58fca3cfb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0347296ff5291f62c63d2848f2caba524c17a212e52d90682c571ccea471647e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73954bd19db5548afb4f8f5f2aafb4a85f67c85d60bdadab0521ee1b1814e024"
    sha256 cellar: :any_skip_relocation, sonoma:        "13a845879dbd63b46e758cc4a6cd9d549c4ac63d6c17ffbae0752c5f168b31f0"
    sha256 cellar: :any,                 arm64_linux:   "52844b839f76c75150ee77ee9973cc638898217b46faee9cf3645ba0a2e7a15c"
    sha256 cellar: :any,                 x86_64_linux:  "93b1e98c2e17d35f27c9f42b6406b188db4194e915a7c403443c5e2b64931039"
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