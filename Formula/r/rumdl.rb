class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.32.tar.gz"
  sha256 "f48a9fc84de8831f3fa9de0b04c994912595f8beafe3e60f6a7064cb13116ea1"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ac849b155f0c23354ac2758679b6e3bdc1c8e93efe03ea6e6d0572855b704ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c27ee89b70b1bbe56bdb3885f4e789acae69dd68825074ff43fcd7a62015ae47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcf61e46bcda56335608758662229ebfaaa4f594e3613f2a279f111230854820"
    sha256 cellar: :any_skip_relocation, sonoma:        "75fe8b6ecfa0f1198b403d19c9ece70b5e73d40f5c1dd228b7309c68543e6855"
    sha256 cellar: :any,                 arm64_linux:   "019796f97920662f3679d766d2387241afafcbac9b9d4080c8466ad4967ed19c"
    sha256 cellar: :any,                 x86_64_linux:  "2a6afd0e08002eaa24a67fc0e57a6b4cbd4a8951d137e6029f21c776822ebe79"
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