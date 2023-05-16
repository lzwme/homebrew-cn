class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-05-15",
       revision: "e5c722820ac6f348c6c674ef3391d7156f1cd1c9"
  version "2023-05-15"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a60f7fa66e1949f5958081e6b4aafd60216d80a2d4af19e12d2b4daf0b328caa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcf5ff66ac0c9967104873c6fd2b2ab14a8046bb53e29ca4fcd1fdff28d9e980"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbcee964e75e1fbd72ea9990c438449c05c2e3625ce2519adc69630785b8b9c7"
    sha256 cellar: :any_skip_relocation, ventura:        "fb0504135682b63c69789c01a2002bd5a893598c1e6d1a44a75eded9e5f3cd43"
    sha256 cellar: :any_skip_relocation, monterey:       "27e62077266355dc1e1a83bff4d79cf07aa7d1deea21080d9c29ea24ec151c09"
    sha256 cellar: :any_skip_relocation, big_sur:        "ebd3c58c59ff84a83ca4ce9453763dc20f639675f9878384481a2e1dddaba7af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a60eb6790372010a3c59394d09d2c997cfea09e6b60704e6f338a1e87e6e5ac"
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