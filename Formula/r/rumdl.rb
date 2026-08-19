class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.57.tar.gz"
  sha256 "d235374edfdfbb54567b2b5cbb26e597d7b6c5b3d3a246e111de893a740d7120"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df46bf2f2c75de7f3dbb449db076e789390e484c0ca759fb162a64eb5e025b31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38eea5ab1b42341a732708ab8de96feadfebeb5503937021391114dc390c2e4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4853da14947927e1e79537d2e7b4cd2fcf49e22de74c88613308cdf3604505ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "b31773e91d8f68f1661b29582c71783a6766c130923bf523fd20300345eae904"
    sha256 cellar: :any,                 arm64_linux:   "bec3a1e6d63df0c9dc86e6e27c3c0473fee30fa2bbaca6f8151f6217a69d38ae"
    sha256 cellar: :any,                 x86_64_linux:  "50db86f2a5a6289ba5619c23034ed707ae83b562f5249a0b49dece0912015424"
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