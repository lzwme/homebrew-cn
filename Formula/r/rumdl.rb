class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.50.tar.gz"
  sha256 "e5abc34554ae41212a5d4e67d0b45e292c2cdb56004801ae63a22ad4e2977f17"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f7759a02d318acde56778f7bc89665aae069ad26683e64dc9b717dad62d0cd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2ba0b652fbc467886eaab75cc75b97a55bd1963a73715ce75a54aa56fac91c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d783f9a7c6eb31ba8abe833170911cd11c2e16bf1185f306b8ab9105de96d825"
    sha256 cellar: :any_skip_relocation, sonoma:        "59b44440b55480e4cdbb740c203fb973f895de8fd944e90914daf1614a3fc9ca"
    sha256 cellar: :any,                 arm64_linux:   "76f0503af48d80f05a0b5f102d881f8bb26560b4a557d21c6f162b985f5f5094"
    sha256 cellar: :any,                 x86_64_linux:  "6a099d08a621690076a30c2aeecd512238d5e5c6f7e146a51af84c38d3af21ab"
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