class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.40.tar.gz"
  sha256 "c0e6d1ba7cddac9112bf038d2eb40c149395acb8d173e5e2ff655123b4fe6af5"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a6fd7492608de443dbc802716d2c97bdd515e792429b07242767ef2c8ad8bbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2dd0de2a0a95099f57fb5bc116d988bde2cc9c16528d1b00c5956bdc46b61ae6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "110d95275edb30c37f551fb9437cdb981020f8cb80214078ef8f64cc47383618"
    sha256 cellar: :any_skip_relocation, sonoma:        "5db01d48d18894fa42a11a76b45e305ba2d06fb3b705fe1dffbf0e86e0d08d52"
    sha256 cellar: :any,                 arm64_linux:   "3e19abe64331a30b23f9e8be3439e4354fa0a56193725b1ca09a2e20e055006f"
    sha256 cellar: :any,                 x86_64_linux:  "8e48b534176d1d97b5099ad679257d2626c6911052c6508b4533bef402104f1a"
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