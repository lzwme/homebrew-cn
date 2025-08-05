class Mdq < Formula
  desc "Like jq but for Markdown"
  homepage "https://github.com/yshavit/mdq"
  url "https://ghfast.top/https://github.com/yshavit/mdq/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "6120705d573c5fc6189737bd584a1f2eff7f76fa94059ada78b207e248534d5b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yshavit/mdq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07345b7b8b7da133ab13345bcddfe62347dda960c715ae5d3be4d02e512d6115"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9d3d408b8efdd1ed1059318678c34df2a6337a86ae713518ba0d7b6ff05d643"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e6fb4e8977309348bc0fecbcca6b05ebfa6dc268466f81d521100e92e4e874c"
    sha256 cellar: :any_skip_relocation, sonoma:        "99829edb50bd38815c41381e8431ea1f05487bc174213fd0f092ae47904e16e2"
    sha256 cellar: :any_skip_relocation, ventura:       "231a4b01c44526e785af44ce2f8634aab4ffd5c5c2f39282645c5f5df4fa5029"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4dbada3f519e1537f706291a77d76ebd509a07a4220f72d8ebeba40c2a8a2da2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56c09090d4ba1270b3254b921497620a6f8905e803148fe094bcfe6df14a4b70"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdq --version")

    test_file = testpath/"test.md"
    test_file.write <<~MARKDOWN
      # Sample Markdown

      ## Section 1

      - Item 1
      - Item 2

      ## Section 2

      - Item A
    MARKDOWN

    assert_equal <<~MARKDOWN, pipe_output("#{bin}/mdq '# Section 2'", test_file.read)
      ## Section 2

      - Item A
    MARKDOWN
  end
end