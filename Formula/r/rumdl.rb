class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.175.tar.gz"
  sha256 "958e347101d7f28f11482deab5689006291e0c271b55e99902d652b8ba02d2e8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e09b474377c27593e182a631c7bec4b541cd4e32bb4f1467489794f0eb89d117"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb3584df72cbe55965cc82cad46264fd9bb6f142e10dc31ffe0993855fcd3ed0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b85535d8018d378f3d9972eb80a73314b2ec19a0e9abb7583134ab3d1121dacb"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a99dffe21bb2df468da2aef57344e0eed08eb7ade949308f34c272cc4f0b78d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34a0c45b08cc22763872ced946d67db65c23acbd8bd2d4bf23d4fe4d781be36d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a712345ae652dfb7e0ecaa9e1cab3069d02781b97006737fc1e89bd12962eb2b"
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