class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "b822986f3554f63174adb3fa53264f667c8332bd484194214675e6c87f5daac7"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "341fa141dc16396ddb1e5494ca4c681fd34c96180cd32e55f3e4a19ace7ae25f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f10a98bd677b08ec09b36ee8790fe3db57c3d5ab61bf8450bd409b928f1da8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9890308dcf54ffb0d5a1f3e759a4c2ebcacc65f86dfa14de7217c421a61ecbfe"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8cf6e210c411dfb251a2bb5312b65c61be24fa4ab5dcb48809b4af8dadfb819"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d7a93084ec52f7fa1df06d3c1d105b2937af3e27b74c19ad78fdc9d87ff84d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "255b06e96e3e34ff836777cb6df184add0303ae233c5728d3c51a8093d91b2c2"
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