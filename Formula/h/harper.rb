class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https:writewithharper.com"
  url "https:github.comAutomatticharperarchiverefstagsv0.29.1.tar.gz"
  sha256 "9ac27ed81ee0b6e076adcb6b08abcc0633ba23df73d982a6f12ee6144534054a"
  license "Apache-2.0"
  head "https:github.comAutomatticharper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38afeefbaa8379637686963b3d63d9e3888768813d12fc0a37b5b2ebb38c11fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68c53d22fb6f08bf32485e68d40dd57b798f8415c8fea377eb8497bbe90fd4f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54fc255a8bc6d6009927f0a6e0710b202c087f218999e695e94b9e0ce9a8dc26"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd64cb49e0239134f85b0dcd092b395cc5fe0a1ebb148a9951876895ba42667b"
    sha256 cellar: :any_skip_relocation, ventura:       "86674639c0e95434c8773d953e71785a9e1811f00b19d3b01e5cc429388bc510"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20fa3c7c3b08b70e1d134b5f543abf619e1018b23dc30d53210c9202047c6686"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bbf905481e903c5dbd5f1e4f19e90bddc487839259a07ccfea189d7867c535d"
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