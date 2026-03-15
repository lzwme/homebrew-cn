class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.51.tar.gz"
  sha256 "e581dd9d3368b898bf7833bd3d9efac7c5b8b36f19b741511ed28bcc850ea595"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8edb0a71d118c6557de616256f830946b72bf52f2d3a5026e68f76ec3d0dd74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c274252ab489d981cd8ff5a7b275df56405410ff91e538cb01c19a57bfe25ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39e10378c31ab6aa3ce0e3e8de69ff2b1aaf71ce64fc183d725c752c0547d09d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c509a9f9c7d0be3ffb5b3fdf3ce518e57964c400d4aff45f4740420677fdf52e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5eb065a44e9212f57b6f01ff124b9f0dec333567c2f19955296dea5b67dd55a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86e3f3dd9b7c7834b1b5dc56d1f1ea465cc7d259518ef886669ad6623c43f68e"
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