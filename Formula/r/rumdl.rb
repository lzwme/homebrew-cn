class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.205.tar.gz"
  sha256 "044cccf22d3b62ba380f675d6fec7f51cd38fd2a8c71e98d1b41fdb5441e232e"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ba18e58175fed2ac2bf16b4f455d1e3dd68f75eb7dab8e7ba88b8e0f3ee939c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50593850be7c6eaee8d4c77781bb4e5a2e514adfc635ab4ca7f93a6fde6a52e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0800073f25dfa413ba8d8c7294739a467fcc15f76a9f38c7c2e7c44f20836e64"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffcb3d82256070d2f62f3fba4992661b3d2774795d6ebd03e5c4a6fd378b04f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e23797fb2e7026eafbac88659c9fb531551baf4d4f5db1e70c758de95f539cea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f78e3b278cd01168da10779935db56b7b996fba40f8ec976b12c2e4c284cc35"
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