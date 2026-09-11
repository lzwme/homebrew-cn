class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.71.tar.gz"
  sha256 "a455d1f0e83c2ad47a5ef387012f0fe106dbc95b869a2724c1be73a6a1ab0a19"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87b47988272c391abb5a209fc3457719ce42271a38f424bea5bd9f55faad888a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4534b98b817265c302b5dcf4e6a8b1c6ead2a2a873ee1271fc8923c437f5c7f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1557ffd75cfb9fa8afc15c4e5062bcb59fcff780a41de9cc1acf4bb00f2e6c3"
    sha256 cellar: :any,                 arm64_linux:   "97c092e0a37bf78cdafb9d91920ebe7b9c575cd4b7f4d6467422e1f8f0b4dbf3"
    sha256 cellar: :any,                 x86_64_linux:  "0cb7090b12eba747f2a34006c8e14d686d0e1ddcb61b550f64c01766039bd67f"
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