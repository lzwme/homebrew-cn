class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.215.tar.gz"
  sha256 "c81258159635deebf946cafa0e8aedb9263b838a69040121e082c7c5e1fa9b1a"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53dab0e4dcb5dc76d743f607f9647a5e90663206b84a047dc2527c4c6c73eafe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6e580c31dad6220c3ca1d853291d3a4df1b688684fa56041019da656e6ca2bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e98aa9ba9089bb6e21a90e0118bbe144ab67a77f6fc01b0035aa42fc15a57bc7"
    sha256 cellar: :any_skip_relocation, sonoma:        "321ed80b81b60aae40b7f79013c85b70d7fa9f7d274ca85ddae8a6f8299d731e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40099e219eba3ba567ff67f524f7638d841737c501c412d0d72bc7535926e57f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1800e677fd6c7f6ce1bf9c35d83517243dac96dd84a0594ab0081eb43569d97"
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