class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.12.tar.gz"
  sha256 "49c34032e834e319036cae8b756bb1b87e97acce626de1553d19473a79cb4165"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a118b5cf70b9dd80d824b6d647c35f95d360c2f54d7038a9b1b1a465161af63c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c740dae2efb6da1f417d9c83448a6c4209b01a55a60c28186acab1416bf5cb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edf125ffd1f356e8d014b71aefae86d8e4b2300946e0e349168fc8ee30b18a9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "89e90b4e2adba751b8d7a1809e830cb9971dcc5d94e39e935a980da50ad33269"
    sha256 cellar: :any,                 arm64_linux:   "b4b916b60beff0ba628f4f7860f539befbdc5d815678724bba1f5610b9865a1d"
    sha256 cellar: :any,                 x86_64_linux:  "62227ca8f692146a2da49d20aaa31b93f5761410cbeb1237f8f0cee672092e19"
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