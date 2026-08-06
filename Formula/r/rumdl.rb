class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.52.tar.gz"
  sha256 "45ce902d13ef0ae2624b3b1595cf5d6e3646605d5c966119b13ec16851d0b0c5"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fb16aa66bb7cff3c3979397c6b5cadec06b33c42aeb1a48882b322441f38d15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bb740bd1ad517ffcc3a090188001438311cd66953e2a8fbdf52f4fa9d6e175b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16962fd1d70defc4a03122425ff362498bc35e2228737ee927b362bb5384a73d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6ca666f90d91cd2d748d59c503251043dc7b85077a819154d448f0547e86688"
    sha256 cellar: :any,                 arm64_linux:   "4a46458d3ee1ea1e9743a683bab7d4fc3bed25e179b87066db64e5db0663f700"
    sha256 cellar: :any,                 x86_64_linux:  "63fa721afbfe597d308d2e610bfb58a99a6af2cd32398dd83c468b46e1bba331"
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