class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.93.tar.gz"
  sha256 "275b5bc1a401e94e2f5cafd35281faf143d492aaba980537203a0f02d681001a"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70a1d5a8964eaf58ef2e2479e59866c02352bfe6c77e664b8ca6d36cb8aa268f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82473ca8cc626438af08ccc333c85e274c453571c6242c0377bb05e1f1277983"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbd5e4b8398ff836aecb9e4545f77545bc529b6fb15d393c04ed8a50fd5ff451"
    sha256 cellar: :any_skip_relocation, sonoma:        "22a851489955df9c82140c135a417c9d2efe255109234b25419abea0deba65da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1ebab57f961f972e9e3aa139ca155b14d339c1a84a16ba75647918535130fa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abbd9d5bfe15713fb6b29228bec291c0c3e47711935d53084e8f29157f52decb"
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