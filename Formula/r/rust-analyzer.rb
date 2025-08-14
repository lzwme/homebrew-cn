class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2025-08-11",
      revision: "9db05508ed08a4c952017769b45b57c4ad505872"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af90f30db89676df1ca4c90ae37e4da7c2a6547490c430b22cfac9b6d59ee813"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "137bfe74eedc428c2ee52441b8db98155d878c9fd7e196f18bfc27240a775432"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "169da30d68c60bf188fac2691bd466077183eb28bad67b696c58a5c61af5c970"
    sha256 cellar: :any_skip_relocation, sonoma:        "106f32c2346122f756fd1c52e35eb466d206ffebc6edca11378c6e97dab68a1d"
    sha256 cellar: :any_skip_relocation, ventura:       "ec97c227c9369fbaabfa063941c203f5e488dbe51889a5930f937e187f40e8a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f6e4868f1ca959be8bd9f6dce33c309d7f6d485d782bb5019fdf5c5d6caad15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ec1e003366d38b15b175cf65b318a36e4da726659e688fa26e2ab8b42599fe6"
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
    input = rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id":1,
        "method":"initialize",
        "params": {
          "rootUri": "file:/dev/null",
          "capabilities": {}
        }
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "method":"initialized",
        "params": {}
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id": 1,
        "method":"shutdown",
        "params": null
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "method":"exit",
        "params": {}
      }
    JSON

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output(bin/"rust-analyzer", input, 0)
  end
end