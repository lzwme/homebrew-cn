class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.22.tar.gz"
  sha256 "ffa94130a747cac3668593e8919b836369384be32ae963650ab972c39db25b69"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dcd57b1e160414627375b2d44c0d26eddd067c6c3549896efed3849736174f66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d43f295e83f2544bf10cd5781d127cc61b5643ba41bc9b53d2cc650d5ae6880"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b0e9a82b9f4d930169240a23ef1d879b7745055d3ed9762a94ad1ede52e0df8"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d8976bb151e7b3cf9455e942c9bf91c6d646c186ea3bcfd751cc1f110df371e"
    sha256 cellar: :any,                 arm64_linux:   "64ac7f0ba7245cc3344dd063a0fcd572ffcd9c34f21cfd73d2d2921a8f2863a2"
    sha256 cellar: :any,                 x86_64_linux:  "0604951a891c8b267b1046be567e543d9c56bee307a5501b1cb9f2d3bdf61005"
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