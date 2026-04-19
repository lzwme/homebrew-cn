class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.74.tar.gz"
  sha256 "031905e51b2e65139dcc0cd9e5a05ebade9420bdf1c910228f0ec5d195b46a46"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31c2b108634a3d841ab6908f0cacff92aeddb29f7e8d2398ae363fc513eff1c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afec6ec3b2285604614412132628adc8bc54ed126d51fa187055f264e86fbdf9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92f38a86059284138401014002301b824d578b8edaa991e938d0dbd297f22a39"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec88518f53f586054696b9a59984acf30e68b117270942dff185afb8c2df7301"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8cfb05824878db33a8156ef50b37f1a74a7e4a0254f44ebbed96c5414abd54cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db28dd1cbf5af9775dc62b171db28864f2e618d191912dc6bf5d35607ad18388"
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