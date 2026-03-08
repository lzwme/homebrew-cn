class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.43.tar.gz"
  sha256 "7fd63ca848b47dd27e05ba66a04044782f258c1e7fa07bf0ebb8f61cd79367a6"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c605e25783a0d854142f9bd5d8c43fa497142c8f692f38717749722e8d39b26c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "daa78694d9d71c7c2cf9b048f80e57d675c5a72e90de1a3b8951db43c7931232"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09c32f3979f736bfe7a731d2e2917f699d20a250c3f7402a95e35f03a059b018"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4028dba194e9d3f704313f9749e6aa61ea0fb71cc6d16ebcc35fd771d997626"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a51a9509d2080c0fa154b39d8ab384cc73a416ed348e1adce2c7b9b4834d3410"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ea7f9c770460815168513b6f3f9f356fdd54bc440c4ac38817fc67eb3a4110a"
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