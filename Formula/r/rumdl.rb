class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.190.tar.gz"
  sha256 "c434b10e0a14b87ac913d57d17c75c591db6a1cef9a64a4bd6b6b62f8e4643be"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12096d5e0ebaeedab5ca762bf443933fe76b7a73fca549858650c654e7cd299f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04b0e27fe99546a20f30e971fc4d4fe260988b9f52f34ea14b94ffd978a6f277"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "402d28c69ae437036825fd0be12e30723b9a1761983a028041027856b67ca21a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f404880819aff3a9e4a9dc420891548c83dc4323e39504e1d0a86548a8cb7996"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4bdf8b4770d73679689826d846724534e1d275fd0f1f020ebb51715ef424705"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9e82978d7a6a87d5c616aa31d9a20924ea20b3084bb7daede5a5f91ebf866ea"
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