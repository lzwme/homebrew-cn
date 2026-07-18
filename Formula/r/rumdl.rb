class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.35.tar.gz"
  sha256 "ab057c10082bc0fd2c6aecb649e0cdff0cce00d6ea9bcfdf8ec4f34f61778671"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36aa927a56057ef90f8d46cc5676368dd95e066f9c87396080d25fb406026f4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7cbea7e6fb8a7358b36713344c014ef40e0eced8ea753f7a8424a1408dfff14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b065659fae630ecd024f127d2ae61fa88210445a0699675211d9effba4e35d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f7ac6c3d511dcf5d601188ebad2c59fa5cdeef335ad6f75607630894ddfecf1"
    sha256 cellar: :any,                 arm64_linux:   "6b860cd49c29b63ce33a27b7dbb53bc5460120e8958c08b80c29c54ac86bc6ea"
    sha256 cellar: :any,                 x86_64_linux:  "b21918b241b33fb10bb822d0c7afc7e4f3fcbb710ae531f46c7f166ea536a26f"
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