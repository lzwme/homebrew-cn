class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "0d85aea9df7c3c21adbb32df098ad64ce266727db43dd8b2aa8e9bb266998850"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6501c7a722c08d4e315e9e5682273e5dceca599afc8bc6c2ac468439df0a4c8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c712f587ab0ba651eedad85680ea18b4894819be69e91fe7f4f9153d9e6f9b63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fbcfe179ea38a2090b3be38ccce15ebbe8481bacfad4f801000523cc26b85b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9bf7defb811add7b4a74aa124f86b10deacedd1106924184926fe4bff086617"
    sha256 cellar: :any,                 arm64_linux:   "e6a45b481929ebd5158b8a3c40278ed89875d0093e830baaf1a848aac7b52ce3"
    sha256 cellar: :any,                 x86_64_linux:  "5a68cdf9ffef161ab69428fa9fbb29e5258d05ab94176ee5478c739aec4b93ac"
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