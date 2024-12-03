class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2024-12-02",
       revision: "b65911d5eecfa562532549ef7e70e460eb042e2c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0c35c493457282d4212209f9dbc58bf1651c4f39af26bb6c96a97060a28041a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d6efbb88155a850ba00a6db6e8eb6eacc522880453dfd13e71c0b243c9e1cb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "231a1daea0134339c8c9cd4c4c335b7262694dd61578b1ae460b93f6c6f12b27"
    sha256 cellar: :any_skip_relocation, sonoma:        "670ea0fe59e141dfae8da8516525f42d1e7274b389e2d9c5e5e7e92931dfee59"
    sha256 cellar: :any_skip_relocation, ventura:       "593bafcab97f61959dca048c396b0b100c9d6a506616517c14c5b1770154c3a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2931c742193c99d483dcfd1ccd9e1f3bf066494cd4ae9daf628d6ef67d5f6159"
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