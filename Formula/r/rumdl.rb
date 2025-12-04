class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.188.tar.gz"
  sha256 "9aa960bf8298f89bbfcf3c2bc91dbfbe4d927453fb8549ee5f377a21719e58bd"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25a982b6570436d671c0080409705aaabc2ec7e0d2484b1ca6af5166f9b8eff4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e43c9b2ce9009dcbb76b8a98f8d59d5ae55163cd83822a1f47dd9977456150cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1deec0295e3a9f33948624ca8ae8e5997cd085bc9c6fbad6976546dfa8871d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7699ead2625c7d55c76fbca99365cf79ca0229d078264c7a4c0903ebef0ad589"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1ba29964a7a1d61dc027f9c4974d9ba6c27ba636d5d9bf891c16419e6ff79f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aed62018f078fe2bcb85181fbb864b3d396a6f7795372b40fd52afc4000999d1"
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