class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.78.tar.gz"
  sha256 "0e521a2a30dfc3f957fd060d9a76734a9b57a164b59c09ff8af0074f43931338"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "44c421a63a6a22e9d4ca1436c056a78982be5647facbf91da98e4a3d318b7e77"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1ccfbbb623afbfcbde0c9aa8545a5fe0ee1b77d1422277d177759a37a8c16285"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9d332838cb7edd0196f34015ae992c000ae624bb17d370149b57da4f103c8421"
    sha256 cellar: :any,                 arm64_linux:       "9b1b2113b82ee5b61483723305afac4752e6404a32fa35f9d4487eb3228dad20"
    sha256 cellar: :any,                 x86_64_linux:      "43557f5c5ee50a35c91574723e7698f8cca35d4ccb77c20cd7f2c58bdefda799"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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