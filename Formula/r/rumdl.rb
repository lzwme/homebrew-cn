class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.95.tar.gz"
  sha256 "7e1ae62bb55406adcf80f8dfcd072d96879a11d71d1555e8d18d9d874ad6f6c7"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ca352f961991e4a6286bbf469fdca2d626ca5ad66f395d1dfd34e4b15e46815"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16691c94dfa61133a04415ab185236b8772df26e2950e00ee1e8aed72e42f28d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9be9b9659e54514e6966c24d9fd3187d884b467bf1b07f75203d9f57640c77ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5744f246f97cb93d706ae4af74c659047761e5c7cf85ccd0c48aa77841fd905"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb358fa5e2e96a73358761e20cde027de76759541d0e235e0c80cef3770bb5bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "810afb6968f6d91fbe4d681354cca621c11a16f403628db6fa96c34838373b45"
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