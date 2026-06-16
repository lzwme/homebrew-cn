class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://writewithharper.com"
  url "https://ghfast.top/https://github.com/Automattic/harper/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "469ec352c9d0705b0e8702f8c704b3eac27045f9b209468864a467589ab8a0a7"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8be5d794aedb2c4af0c22387f7b048c745b3ac7709c22426d924bf93f45af4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9c261078774ffe78d7c9569218a5711c4c74e4fdc00809ac83ae1396f995e89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e75559c4aa56586ac930a6a29eb67a627a947232edb0cfcf63c6b20e1d86bdd"
    sha256 cellar: :any_skip_relocation, sonoma:        "3387ae6c6d64a7c3441fe956a5fbf0a468cb5fca6e008445a9836fb91026377a"
    sha256 cellar: :any,                 arm64_linux:   "4bc586d1e48e4a2dec3214972648c830d403d57797b318afe2a26b850e44fc84"
    sha256 cellar: :any,                 x86_64_linux:  "c49bd3102b05f25739b45c936db6f9698e774d5e3dffecb3150e8dc6e0cedb67"
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
    lint_output = shell_output("#{bin}/harper-cli lint --dialect American test.md 2>&1")
    assert_match "test.md: No lints found", lint_output

    output = shell_output("#{bin}/harper-cli parse test.md")
    assert_equal "HeadingStart", JSON.parse(output.lines.first)["kind"]["kind"]

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