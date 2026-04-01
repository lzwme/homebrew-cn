class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.64.tar.gz"
  sha256 "a39f3918a1d92da62024bf2bb41c0b75ee6bbb174149d7c0b7610dd52f915e16"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b181c7592885c87532040042e03c037b45a9e6b73a04c26b2489b430cc61ceda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "268283425ada00e422efe0cb579037910291674f6043ec5b39dd37c403e8169b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71506dc70ff5e8733e7b9f7722374f40da075e40bf00886238db9076957e083e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0903641c723a6cd1749e471b84779df33249b4508dd9e317598438bd78499a7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "522819c24336df6842f12c6852f9e95c04a7b813dc3f570b061c21591938ef8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6098eb418af9b05be68ad757d33aef2069557672aac2840102757df92b3cdfe"
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