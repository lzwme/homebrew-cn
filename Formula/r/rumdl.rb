class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.45.tar.gz"
  sha256 "442b87e36c6cf9de32d55a8397c9b898814525ab252bda0e62b9bfdf805e552c"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23615beb9b26b20afd99a966d90961e4e460200fd0a9e467dafdee9f9e69fe58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad1b11a91c7f10471bee5d5f8e0f69d2ccf1000e59a1300e047167056ec5c87e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cebfc9c48a8b22481d8f1c1bb789d757ed8836b38c816105e10f05e86c0488b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb47f696c859c7d0084cc7f448b3b935def346708f8332dc85d3cb073d18c658"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "596556e2098b5e9d374d47e4d554df62b72b8c45d0f6cb1b7b735f6a80d073f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "985cd0eabd4ff26788a28fdb6988fae4fc5516b07de6ddc6730fb6ae4e2702f8"
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