class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.66.tar.gz"
  sha256 "7ba9665935bf993cdaf18ff722441b690c0a1a6682c4192fb07356684ddb945c"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42be9219bb081f0fde9ecd14ebb985ca524cad606780d4be8289ca48c7820940"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc4dc40848889c37ec4e9a5d6eb178fcf3a9722f1c242e2e99ad2fc3f70732b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2b2b6e3d81fb5cb8ca759ab7f27918dc40d054e10d1cda48acd6bac9e8fb229"
    sha256 cellar: :any_skip_relocation, sonoma:        "009b6d0b67c1e794c89c43e9ea76cce0bb42934572d84b0fe8164eb1005cde40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5f829f80115437b16f3c9fe9668a4ed65a5ebca8fd7d26d6e18102777992a95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9af38a83424e48fcd079c0d7e47520a2416574d94aa5a4c17f282b7674b611c"
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