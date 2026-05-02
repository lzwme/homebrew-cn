class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.86.tar.gz"
  sha256 "0c018bc9daae2fc914355e23413f6a769a8bba922be257b90e6b65047e5b9f0e"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ee541f540c2cb7bb8b2a5265e19f67ef400c5b59dae8513a8984faeb03ad5b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bc4011ce315fd9452a1460ab5ceca5045b8be3eba8a7f700c89e0196a9e21e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd696eb6a2e0e361e82b6def8e4fdef5df530f57c39c945987ffd139b3ea3f71"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0caa9836c1aa8ba1482a8ddd52457317585cef432197ec4e06ea7b43f5ba546"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8907f2760a018aa49b2b04b66903bd4976f0aa8c0951217846e31223402be4c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4075916cef29c056640a10ee65b209a419c977c061b24a12235d66e4f9618306"
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