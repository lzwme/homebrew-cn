class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://writewithharper.com/"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v0.53.0.tar.gz"
  sha256 "51baba0379ab0bb4cc0eb124a6f2100037848d0703b2e58de07791ee1a54bf83"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c50d1f89371eac67d00386244153ed8a5b4cf091d1045c62c2916cf7bbc08813"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "882c3313eba74281d4a2145a11099939179f8ad0ab59f2f812d6e7b2858928bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c0dcf872823d7c217ac6a31747812e8245e505a17abfaa66348deab1657c4efc"
    sha256 cellar: :any_skip_relocation, sonoma:        "c15074465cf642e67ef8a287ceddf14d03888fae804d74fda673ba01e60405cb"
    sha256 cellar: :any_skip_relocation, ventura:       "b1a2f2a44ee36687c8d2d164f6de4db24cbf112d96211eb28ebcf106dcbd1998"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b7ecb100e626f8555a8e247c074f808b99bfa4f7c897449e14dfe7e518def7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dc2e1e43f5468f8833a737ae2617d53aa53a0727d4ba30d0997e16500ac490f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "harper-cli")
    system "cargo", "install", *std_cargo_args(path: "harper-ls")
  end

  test do
    # test harper-cli
    (testpath/"test.md").write <<~MARKDOWN
      # Hello Harper

      This is an example to ensure language detection works properly.
    MARKDOWN

    # Dialect in https://github.com/Automattic/harper/blob/833b212e8665567fa2912e6c07d7c83d394dd449/harper-core/src/word_metadata.rs#L357-L362
    system bin/"harper-cli", "lint", "--dialect", "American", "test.md"

    output = shell_output("#{bin}/harper-cli parse test.md")
    assert_equal "Word", JSON.parse(output.lines.first)["kind"]["kind"]

    assert_match "\"iteration\"", shell_output("#{bin}/harper-cli words")

    # test harper-ls
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}/harper-ls --stdio 2>&1", input)
    assert_match(/^Content-Length: \d+/i, output)
  end
end