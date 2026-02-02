class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "3c37d4e2499cfa4adedb66b3d62f7f8369ec08dc3d572e044d0113108c8fd909"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3975726e36cebff6a18ea56dd036389c91d049c943a4af940acb9f3524daaaa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "077554eb67217b38c9158332f7b068a4635152cc1594ab3065de62411160f52b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da81f48eb2a5e0c4ccb7a969735acb03c56645fa671951347ab59fc8848e75b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "26461c61899e74493df9b05a7bf28c585e42710ac5ef73b090d85ab3ff4623de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a3716ec05671eaea10b7063c29010ce89a7dc7bf4b3c54d24b77cecce8c1be2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8a25e3d085ac2a38bb777b92a1733147f4a882cb9b3fa664f7823570354a421"
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