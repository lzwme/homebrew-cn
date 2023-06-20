class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-06-19",
       revision: "cd3bf9fe51676b520c546460e6d8919b8c8ff99f"
  version "2023-06-19"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4cd6bbd4e158471a38e1e040cc3d99d076edb4decdc125f3383825863cfb8a31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c31eec8ff7899ef4283b4e6c7b5418a39756755206bdba3f6cd1ea35634dbf57"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bbec38052a2743cace11f062313850cc8bb6c167b679bf144bf7b2e15f7d30fa"
    sha256 cellar: :any_skip_relocation, ventura:        "5744065bd3e39e8814dc3aa1cd395cc7ed2a3ae4ecf675feb584000cf4f4fd0b"
    sha256 cellar: :any_skip_relocation, monterey:       "a646d9ed7bddd95407906549aff7acaf46a7dadcf0b3916199250f3f79826538"
    sha256 cellar: :any_skip_relocation, big_sur:        "c49139b4acee0a202e259a40dc3a3a365ac1cd7af77f45622fc866d450fe99ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7852bc232c535dc986c1cd85301a67192960d0611a7535975cf3a00a8f2e8e1"
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