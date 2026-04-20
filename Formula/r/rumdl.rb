class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.76.tar.gz"
  sha256 "e3e3172d8a982daa2f62ea676fcb60af0a85cef8bc773e26ccfc40924569e2a1"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03e69a77ac21b67656c57e1ad63dec968ab49966b2a1932d97d6902bb512237b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ee1a4ba2e59ea88832ea7285c689743fe3e6b3cb486bf7dcc43e640109bb472"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab0552cc6f254b87d3e3d9309adffbf45c6e675cdd154495bd133418b5d5bc39"
    sha256 cellar: :any_skip_relocation, sonoma:        "74e16cd42df52156e04e51ef12e54125dedd5e0fe308b8b3586ccd6c81f70ac9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2132a125d201b47fa4d85cf3de611f1692f5cd0e645b1773b8fed9abc1db00e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bbcb942a03a65d80651b222076c056d75fd6a7aca67a308d1f6e7339532be3b"
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