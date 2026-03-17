class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.53.tar.gz"
  sha256 "542273594c1cfd9cbb238cb5f65e6f94ae16cbd6d7ec91edd2386118ee3c0e80"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f257b95bc9eda425fedc37ef256926bf6fa8b621ed247b3c2cbde3f9de061ce7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01309b88cb186e8bf38e58e6fd1474c6cf980a2a60783b0a04085aed43851e4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ccec058de8938c6bd3229388034b85d333c0ba06bb4e7dd3209af391fe09550"
    sha256 cellar: :any_skip_relocation, sonoma:        "699ee0c91773acb78625483d4656c0e13633e8d9f48c89cd954376c841c2613e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "884187944eeaac96e0f477781674564e6aa13405205486ec163f54873fdd311d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d2e35b37530f8f9fffe0bcc19645301bcfe677bb38df00d178b345a73d07a9d"
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