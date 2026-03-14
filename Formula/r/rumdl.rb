class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.48.tar.gz"
  sha256 "1073ddb586f0159e1c7984fc05a47b8f42bf213d5f9ab1d12392ee8cd88d9b8b"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4a6190bd31aa1e3dde2c746485646155a78e3d31bc4ddd4d6638d4c3bad30a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f424bf98d80d7a2b004282ea35c460a4f7784f83ead0d52550d25385f059e312"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "caa2e1354e5fb524af9d28959df2a2f80827448671857e1d3acc314b6ecdead4"
    sha256 cellar: :any_skip_relocation, sonoma:        "a55cff341b64ae07840a587d79c08f7b74674c0e29ac370a5d084eb674814e06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbc764cde21bed4d264c90e2688b774802bc7ecb100dd094ebdaf05d8995f67e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f29d24137dbeeb0f8c00589e8b6d533ae43c0ff310dfe25f56fb1e32bbb30d76"
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