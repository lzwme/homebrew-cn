class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https:writewithharper.com"
  url "https:github.comAutomatticharperarchiverefstagsv0.42.0.tar.gz"
  sha256 "705e1fd1d33b0d37f0d2146e0ac6345dbcd8dda448f3c61c9f827c8391a906d1"
  license "Apache-2.0"
  head "https:github.comAutomatticharper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4d03c77fdcb153b9df893f7b26ac061d39d60df015a793b973d5af291bc118f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e29dcd9c4e7069d9c3ec06d234e66a04faab30e4bcb1564b7d691d5ad87815a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fcc8d4d333d44a027ef2e488b3f95e493241e73bcdbd806922c9e76cf47e74c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a431137296539342a75db0d97b1050554da942cad74ea5138810305498b4f0be"
    sha256 cellar: :any_skip_relocation, ventura:       "6e7c1a9dc0cff00d9f219a02fadb89f52edb63672ef5f4965cecdef4683b04d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fce3d31a1687e4b1c4466f41a8ea787547cfa48282f7d6782fce586d4feab425"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8ad78c3b84271e11a45ec440a1f2ccc33afc1837ba268eb6c1adb2c5c7a542b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "harper-cli")
    system "cargo", "install", *std_cargo_args(path: "harper-ls")
  end

  test do
    # test harper-cli
    (testpath"test.md").write <<~MARKDOWN
      # Hello Harper

      This is an example to ensure language detection works properly.
    MARKDOWN

    # Dialect in https:github.comAutomatticharperblob833b212e8665567fa2912e6c07d7c83d394dd449harper-coresrcword_metadata.rs#L357-L362
    system bin"harper-cli", "lint", "--dialect", "American", "test.md"

    output = shell_output("#{bin}harper-cli parse test.md")
    assert_equal "Word", JSON.parse(output.lines.first)["kind"]["kind"]

    assert_match "\"iteration\"", shell_output("#{bin}harper-cli words")

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
    output = pipe_output("#{bin}harper-ls --stdio 2>&1", input)
    assert_match(^Content-Length: \d+i, output)
  end
end