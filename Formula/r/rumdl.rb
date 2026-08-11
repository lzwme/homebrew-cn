class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.53.tar.gz"
  sha256 "e1e6a7f26d0a21106b58e623a31ddefcee93a37d6984dd7e602bd66355deb16e"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01faf3029f442359f931b911ef26a27bdf4970b4100ca846c575492f46d9935f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebdd278aecc826e5850a68f041fb849ce950bcfcbff9e7d61022cbcdf901cd49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ccc139640933c4aee3e66a4b2cb725f5334b3de87bf6138bf6d04a5faf90c4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab33ff7f5720f1fa83bdac3ba49b72aa08d6e425c6b138fbac7c1957def837ff"
    sha256 cellar: :any,                 arm64_linux:   "d08552baed4cc80217e6bf924276533f15bcbba880e8318e1b2b9bb3126c0212"
    sha256 cellar: :any,                 x86_64_linux:  "8a90280c41fc58fd429b0cd930aad6fb968be32ecb924424bf23a8571f6deb08"
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