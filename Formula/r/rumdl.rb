class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.49.tar.gz"
  sha256 "b8b1895d4bf1bfb6854d73cd34c11d708fd037d871572e92eb5a79092c363dfc"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "327f20f2da47b6b6c13ce884962299b4f898719b1248c5aa951e2e5183067b1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53894820bf1712622ac1ef473221ea30822edfe93eaa7d4342fd9b4cc8e65e78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc0e0b014f98b9665cafb616cecf1f161670ec7a2e3118147cfca6fac710bb8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "086bc2a894dd56f1cda379cce4590d8858f07091bab34d9484ee89c639718dec"
    sha256 cellar: :any,                 arm64_linux:   "4e253ae265269e99c8c99b392e783559989530bea4fe00b89c584fca7d52228e"
    sha256 cellar: :any,                 x86_64_linux:  "cd374c00beddebd7eabdb75217a7428117a8f7149abfd3e49fe4473d6091a25d"
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