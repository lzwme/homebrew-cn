class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.24.tar.gz"
  sha256 "6bce3636db6602c31794f4dc0076514303566afe0a0b1e96f9758d305c790e43"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d2a8c82d2377fd2cca0d4f0fe2a54ec8f057740a801d9ea15c2d845975c5e56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df4c936100843bb6153672b9b31b3f5bea16c1d1d330c21d2c1e195725f7f7f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9407abc93d35b05675f7169d610d0aadb3df40e8d405c7d71f5184b81690f0a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f85f282bf20cd58c0d491ce972a26fd78583c337714895e77440bafeb33b2bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f18edb4a389f5c57638365349ca2585bda11bff08834b53489d54917b8be95a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96c06277fce7c49498c62817ab207f3cac12c9ee85e8dedc45e4f9637ff729d3"
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