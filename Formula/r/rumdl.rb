class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.208.tar.gz"
  sha256 "080f30676cb7e2a30f77b41645447292e434291094768f10f15edff0e838b3a4"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9b6614dac26702d6093aab8533b8b61edeae0108f460cc81a059aaf4a20b31a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b59f4b522eb54e1f35e8fafef85f6f74a1f4b461ffd3cd0feeb3a2b39c54e32d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "143cd17c24ea7b407e9a63a006b128952d91ae057e595792ef23782652a3636d"
    sha256 cellar: :any_skip_relocation, sonoma:        "cccb706b87b6a280565ec742134031e1cb5c39dbca320bfcc36907a5ca1aeb1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6261c0595f7f5443cd876569e374c3b4240f34e95f7c92825c9fb73207a9a7cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74e64d3661b43e92f036ead5b89016846763f2ede422303f95c2ac9dbbf346d4"
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