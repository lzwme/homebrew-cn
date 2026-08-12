class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.54.tar.gz"
  sha256 "b65ff8e6afe0e39d1fc30e05d98779311a14690f7098b6e3f2406c696d090e3c"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06115a7a7f8b6249a9a0fbda1795dbca92d988eb2cada41ea19735da6e25e296"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd6f234e1f0aba5fe0a70980695b90821e6c28c174fab8a58c7de9bb1aef7c1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b9838d98819797b0ea18b2b95c112ec9a748b3c18e7dbbf36cc1b0edff9d47c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5dace85cde471381c3f0bed221ef7f29197515c7675cd9a67d85148f588d5d9"
    sha256 cellar: :any,                 arm64_linux:   "9f27c2c3386f1bdffc19b8db1d12a67b3e807c156c9a57b53e99700f7f451779"
    sha256 cellar: :any,                 x86_64_linux:  "9f23219dc1111029f17d21e81d2b5d852dd2ec707418be71c827fec58e24e2b7"
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