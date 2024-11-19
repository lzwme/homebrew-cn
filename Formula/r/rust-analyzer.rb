class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2024-11-18",
       revision: "ba56d9b9b5f7ae7311b4bd1cc47159d87eb033d0"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12544f6a233567ecc4c1acec8f77291807d01720359fcd9d043e0db19d1f2f95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f0a4feadd91f4a5c88f47407cfe95c1b93983ba8b80dc8c8c7fc42da963b6a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e38ecaaf874cda94559d6a0fd1f8bb326e287bd1408bb6f73cb482d8235b3fde"
    sha256 cellar: :any_skip_relocation, sonoma:        "748d89ae5fb761274d3b4bc0913dda63bf2bcee8cea5c277124b6ed2f7a22b77"
    sha256 cellar: :any_skip_relocation, ventura:       "0995229a3af4e3ac9c30795cfef88e71bacf55f924da38f518c8157b15bfe626"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c64e08afb8b3dc440bd6ef439b15351f1b86a9e64effbc95ecfab8ff45ba9e1"
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