class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.27.tar.gz"
  sha256 "ffe8323458f351e949b28255ec40f02305f2b949abefcf680692ccf828914d5a"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7140c6807967838244ae735d9955d51fdb38827e9123756177b377fd911ea3bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2dc83e39a44a79e9d7b819bd50ed9bc12e7e9c5d651ad7a0d5ff9319785d37ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bfc49f0584abb813dc275a04a38dc7558226507ce118c3c0bc9832c7a984b0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc83e742407d37ba3276dff3369f268c7638017a6a489006b442a15ac2368b50"
    sha256 cellar: :any,                 arm64_linux:   "248743cdd4222d7601b1a3b438340ea5d8f63e0e459fbd5f35b621746c456fcf"
    sha256 cellar: :any,                 x86_64_linux:  "d9e2b16bf39b5bd25edcb85554461fab37e952646c880d957a12195d9244bddb"
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