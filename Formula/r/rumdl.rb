class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.178.tar.gz"
  sha256 "a69e106562d9d482652c3157e3857573c5752efdb29655ddbd0a8b988a74a7d1"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49cd1efa4ccd107b9e22b9deafaaa0c59d2f33c1a774a15e4f038ca52d507812"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17340b64c63af5524d34acbd44e3235882d254745daeb62cde2a4b41dfc16d56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0c618b0846188bde52c45ecace5bcd28c2549e3e252beb460129013186a0f0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "291525ff590ca6195b1965185c84ab6fc1fef14b2097e55fa8cee7968aa9ac44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2214c8cc3e4da4df81618c555ef8fd24aa20f60a10b7b383a14a7aa1d78b8ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4332c26fb866e776076f668cfdc830a63e09f17ce2be394a12844e4b02a795e"
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