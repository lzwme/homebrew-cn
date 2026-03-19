class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.54.tar.gz"
  sha256 "984d3cbc6709bf0d67824fe62016fbb39f9fa632de4149f00fdf490bc78cae34"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ea7c87bfc64fe3099c02795cf5cda5f26f48d5e92011c45e5b4145d2bff11a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e610a5e67f72af9ad9e0d4e3a0fb699bd85364fff2329c6e78b9d8298ebe94c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a20f98b77ce70ea71262393cbf636f551b200896c75812384b74b1930ea79c2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee72da65189386a63e832296995c8cb42f3066d47a38fa34de5220eda755570c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a7b6c0f54b6aa58e1b651e9c70e27c77f16786f7e0e44316b73ac488652ce64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db4fb5ec5582ee9169e0b4a25f19db087c9add20d2844a6f08697b38cb87b123"
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