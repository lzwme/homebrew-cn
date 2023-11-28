class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-11-27",
       revision: "237712fa314237e428e7ef2ab83b979f928a43a1"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f19e88c8a64d32e153678dfc585901b6b3fbfe05ffc7d39d0d22870454f7b1a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b25a9e5fc620dd363af41956a3096527cb689b524552e6e39502b44f8eabd517"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67396558ec1f070df7ca3123db76ae50f38d18934dc4812976eaf5a280b9635f"
    sha256 cellar: :any_skip_relocation, sonoma:         "87f344bec5c66290a71a957adfb9fda6b224b00a9deecf77e79517ab4eb8ef1b"
    sha256 cellar: :any_skip_relocation, ventura:        "8dd9a6941ebe117d9899931e6881f39add52941fae9e21bfaf92b07311f19205"
    sha256 cellar: :any_skip_relocation, monterey:       "c2318dafc970e0ac90f6722c65dab634b5bf1c90eae6612e0b846af037a95a9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a3b732d7392b2c0f9f74e8a4a6a90417cd7098d59edede47a1ffd7485346ab7"
  end

  depends_on "rust" => :build

  def install
    cd "crates/rust-analyzer" do
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
        "rootUri": "file:/dev/null",
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

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output("#{bin}/rust-analyzer", input, 0)
  end
end