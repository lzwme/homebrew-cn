class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.173.tar.gz"
  sha256 "b52d7d6c4baa0ff6a29c64bd7a66607d51fd71eb3443612e7db44404c3299732"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c315bd0ac0443b76ff712baf255ffca117a34259b3bf54de94e634ef96992b12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "979fd8f75b725486e9c3f1d01f1f024d46c55f12e6ba3123df60d11fdf04fd3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83eefe89a1a774cdb61726373c0c0cd9f7d7962bf44191c74ae9f418f44f060e"
    sha256 cellar: :any_skip_relocation, sonoma:        "736a439eddb7483b784209c7b8da8282bf0cb259031dfb9579f001a03173cf96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33b814de1f52f0108bcad8fb681178f8b2bcd9a3df3cc69d1d68f66ee4aa3c42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60dc1a128302986847b69992eadd0350f051b19e4be508b533f8619b43ac31c4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
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