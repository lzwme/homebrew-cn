class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.26.tar.gz"
  sha256 "910903222754a5c0c90b25ca99a60e589777ef214d19e79b32baaebdd5dd445d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e377c2e67f4010e2571d6679853e8ad19f4b5d65b1883fdabe720de3374a1bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e43e43bf4d9ae82f2ab6da82015d98964fcac8d7189d236d8f4ed486a4dbdbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c233e99871c2b8e794c33f70b4a57b6e0882c7fd8808d5b1f8aa8f023e14615"
    sha256 cellar: :any_skip_relocation, sonoma:        "1400ac0789d209b47df6f2ab90a238e7898a47b0fa64b6d8045caf28fa654d0a"
    sha256 cellar: :any,                 arm64_linux:   "053c348a3329f8ef9c398850b2cd720a081cbc32ee50965defdfff1d541e5b1a"
    sha256 cellar: :any,                 x86_64_linux:  "01d59e75fd6913288364d3b07ac5385ef6bbb603113b42ca5cdd28b73dadf39b"
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