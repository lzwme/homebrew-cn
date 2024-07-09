class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2024-07-08",
       revision: "a5b21ea0aa644dffd7cf958b43f11f221d53404e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "03ca6903498ac3de98035a9d5aea09e27a361d167879707d0119aa1a6662cf98"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b19e9cee695dc8626d6dc77cfe9a657ca05798f46842ed176defe1a45e58fdfa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "193c51485fecf6ce2c356cc61d8f39833d761661678a4d52483a33b51383199f"
    sha256 cellar: :any_skip_relocation, sonoma:         "751dbfb5bc97c584a1379ea40c4a55e1707b5b914b4b5860b24d5bfd31a6e6f0"
    sha256 cellar: :any_skip_relocation, ventura:        "0dd1f038d6aac96544209f0ff8a403ceacd3b0b7f5005e8deb5d5343097b3ef2"
    sha256 cellar: :any_skip_relocation, monterey:       "337edacc24af3e7eec8b9684b35ad5b74607e3a88f8c3dcf131b2c38d4efe183"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6958868bc593544c8f707f0eef5ef050c227871c5890f7c599a6b2d635bd211b"
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

    assert_match output, pipe_output("#{bin}rust-analyzer", input, 0)
  end
end