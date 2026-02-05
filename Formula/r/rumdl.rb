class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.12.tar.gz"
  sha256 "89f6b20c31922a0713a38ec33f10f78b0a2bd12d4c2b1cdff82b4cf0a9ca572e"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56e8000987433c13003299902e9ca1f1ad06432c4377581b2733fcbaa05bd721"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ce68956aae518941c28ce7e341e02bc33b06c05b24f82ecb397f46b78c70dd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "506b37721b1dc1cf91fe0a325d31dd9c352ab53a4f163be5afa2eb601fd17f4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "84acd3f4856b237614491f3a2faef135a53690e36cbaf1131235f0f6a47e7d5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fe62482fc04488fd4d17f8a2b5b22fbca79590f4e865bb438ac24dc6c1c0a97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "313cc64818ef5a0338c4df7cf3aba385ed0145bb4319173be46bb8ef151bf4b2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
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