class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.187.tar.gz"
  sha256 "889052cc5f87e8c540d3129fffbbbaed4f51d4841ad35f8e158acbccd8e888a2"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc6edeb524c9fa14e079f15c180a3c04987fc0dc34ad6038879816593257ef13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "809f15a932eac7dad6f398b37bade641a4ba6a34a41b9b545e83a603ba8c392d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1773cd901f1d8c9bb78848eb4b57bdb9618f49fb88d0dd53768aa6e79cf9d87c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2386503795038a0e8941fc0f6b1bfd9db8c0a876d5e3a3e54292b3a693b7981"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc5f679eae6d7d47214c4e651d59df11be25fc4054ba397328c3d55496151f90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "635b73d20afca6fadf86831afd5d9d46d3199993c51d9c781196e36202398df6"
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