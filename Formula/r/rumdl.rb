class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.48.tar.gz"
  sha256 "660b5b1bad00dde0dc00bb9f037ea3c682508636832409d3c853fca63e27eb07"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "722dd41c5589324b0364e2e09eb85f0897928ab6a74bc544da321919061ef575"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f5e83b1fea4c717a2b47ee6fcca13b893ae99d0c95ea918f261e3cab5df1ad4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71298d29d02416ac19e11c2dd78982c573ed15d568e952f144945a53578bc411"
    sha256 cellar: :any_skip_relocation, sonoma:        "db0a78cc4ccd7f2ee1c14848846af855719df14ee4b2d4e04d28751194054ef3"
    sha256 cellar: :any,                 arm64_linux:   "acb2a5ce9e3453ffcaac6f05e4be8021a322d07715896febf5f098d13d3c8219"
    sha256 cellar: :any,                 x86_64_linux:  "cfba34df76af1485b3598438ec94769708dfb8f74dd6f0c47861b7ad39d90fa9"
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