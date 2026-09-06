class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.66.tar.gz"
  sha256 "38672e4a5646076ceb31ccefb056b9a653fe25009b3c032a7c470b9d04c05d43"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "634a258d0e85faa2d252e2370ab10e0ec0a0a7884676a8f2a43c4ce25df0fb3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a6f9f59c392e60386fb5797309b873500f5b13c826e133fbf7660a68dd211b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6601608f3bfefb9e0e1431151848c73003da521a271361485d3775a518bb753f"
    sha256 cellar: :any,                 arm64_linux:   "164e07eb28432fb76a2a72916d978833deb817d061f3ca030bf2aa769039d0ba"
    sha256 cellar: :any,                 x86_64_linux:  "f03c1086ed87b970d2cb8afc8a23ab2331d7beb771ada8837ebef5b20176f2ad"
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