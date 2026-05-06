class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.88.tar.gz"
  sha256 "91685698a487dacc77e85dbf892e6c23236a505ae6258d2081065e25ac2f1358"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1618e23604d0ed76da8cbe9d3e55769d480c8154394d30c36831e44c18bd7572"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a5782cbb7c86719f55687b72bdbb06a3c9b47da5fcfa6fd8557c594ccf8928d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a46c1a3da1eceba73a1216e82308f58f390a3b794256ee60459f59e3ad74602"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5821a4b4046edc1754633b8dc6ba39e36f898a00e6f38f1729659caafff396c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a20349a2f04d938d5e8f3e990e8a315268928d5d4aa567cf9a96dad6aca7c0b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "595dcced3a1324c8e8de7c092bf3592d36adfbdd06cb48a3357ba25b5c4e45bb"
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