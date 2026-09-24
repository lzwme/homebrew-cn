class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.77.tar.gz"
  sha256 "def1ae52deb73257a1e40c2d791d213cfb36b7676fafb8801ac6b25d50005349"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3490e4dbefd02dc04ebbf9bd138f3aff640b578fc9badc38665580190c3b0bf2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4223f6a92b90713fcf5a7c823da2d72e842313396bc8a605c6409282ff461cd8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aa0c1c2abbc8b9e401a721d1b1004eacc13627cc1f22d25a20a64959574e4029"
    sha256 cellar: :any,                 arm64_linux:       "78f86b73706f99f0fce125dbb96356d679a7be6aa9c38b84d5bede1a75aef0c4"
    sha256 cellar: :any,                 x86_64_linux:      "8959cd39008661b994d011d69239bf47e9873023db9b0260ed592322d6e39f39"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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