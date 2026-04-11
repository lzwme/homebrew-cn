class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.69.tar.gz"
  sha256 "c0380805d8e10473cbe016fb2d6916c9f11c19fb60dd1a9c336677b2320af84d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c962ad7f6da801d4553ee1b67ac0a38303e93744599b1d4c230aafd1abbb68c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e79efecbad496e347e3ca589de8cfbd7a34951cfd8ec120087e571afc2aba534"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d65dded3560a9ced2f4b58d77dc1dba19b6e308759b4cb5493df97e57a3c19f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "04b1da5f5804cf6848f80c12f9f74a2d82e8ca2c56d13748f17f95d0de609517"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e579657c8f7f8a1f1e1e435a92abd22312657dca83301db363254437e408de9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0755755644f6a216b7413d4a8d1ad74e01b02fa52c093882ea2394123b726e93"
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