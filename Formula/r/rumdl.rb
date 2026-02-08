class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.15.tar.gz"
  sha256 "fa6151c6999acb3eae3335dad6c9731d24070505212c7160e8038ed54ce87107"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef52cbda0e097fdeb11384f57c1d2093f29e9a8633fff02b507fccc12236f12e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6aca33bcb684d50812068a29cfcef8aad9ef8de1dfe5f0c64964efd7dc7a9d89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c46c1d5905e01e0841712b6f560711727318753cd27a2de158b2e55d808b1191"
    sha256 cellar: :any_skip_relocation, sonoma:        "a47dbb93b3875387898c53e08c3c93239ec403ebc5248367dbc434022c2ed986"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b34703488124a8af14fc0574dc343dcf10bea0a5aa836d9d9334c6b389dc9104"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d163b7b427db470b459432bb9ad9ef941b48e99156a499ea35d3146468b13287"
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