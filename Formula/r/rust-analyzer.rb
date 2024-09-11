class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2024-09-09",
       revision: "08c7bbc2dbe4dcc8968484f1a0e1e6fe7a1d4f6d"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4ac3b1ec53defea46bc2e741986e0cb7f36ec6e3d6ed97adb01d49a04a68e9ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "594852a19371f68756148e1a9e821e28acdf283ec218452098fd2e56b43bce04"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45fa24de442ab05170eb6f137b367b798309ec658c3af4a2b4d4c88b3e040dea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0eb8a61c19333b08149a4c32fc731b42258d20de51ff1528abf4191969e6cd05"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9c7578585a87406616f9b7fc60c0d813fac4dd420308742876c56949c210282"
    sha256 cellar: :any_skip_relocation, ventura:        "08a44a40e999da2805407da8f15e0dd834b49c3510ed2e7661381e5d0e798c76"
    sha256 cellar: :any_skip_relocation, monterey:       "0c54bb4b67ca05ba09d2bcd382300519b746f236991cf21b54487d933afc2b3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "052e3559bc25ca86b59319c955fcb789f456a289d1f7e4dd574809c968cd1c5e"
  end

  depends_on "rust" => :build

  def install
    cd "cratesrust-analyzer" do
      system "cargo", "install", "--bin", "rust-analyzer", *std_cargo_args
    end
  end

  def rpc(json)
    "Content-Length: #{json.size}\r\n" \
      "\r\n" \
      "#{json}"
  end

  test do
    input = rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id":1,
      "method":"initialize",
      "params": {
        "rootUri": "file:devnull",
        "capabilities": {}
      }
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"initialized",
      "params": {}
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id": 1,
      "method":"shutdown",
      "params": null
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"exit",
      "params": {}
    }
    EOF

    output = Content-Length: \d+\r\n\r\n

    assert_match output, pipe_output(bin"rust-analyzer", input, 0)
  end
end