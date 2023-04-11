class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-04-10",
       revision: "01120f1213ad928de7300a8acf9f41bed72d0422"
  version "2023-04-10"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "deacc923d0dd59c0fc0c775603d05ba0ab5cc2346ad00933cfb92a52f80989c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0cc54ef7f082e36767bc6bfe637bb77ae52d36cf8caac4459f127c7d0b13346"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "363dc5d6fc153bba4091159cdfac58c33e3bd4f2fdcd27c9b336959a5d046574"
    sha256 cellar: :any_skip_relocation, ventura:        "99714846522b27b760281f53509fcac5518b7c6cfc45d3836d89d445de4c6611"
    sha256 cellar: :any_skip_relocation, monterey:       "e1404fb8ec26083437c587d5031e535496234fef572bcd902940e70ee6f52901"
    sha256 cellar: :any_skip_relocation, big_sur:        "acc86de73c8d328d5d6594ac9b60937a73d10a25fd10e927c33c0c6eef167399"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb9dd96e01e961863ff780b1fd1ae7850c2418ddce00a3a80d83253bdc88fc53"
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