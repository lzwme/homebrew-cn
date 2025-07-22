class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2025-07-21",
      revision: "58e507d80728f6f32c93117668dc4510ba80bac9"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fb31253e504eee8e1aa0214800ed7f86eee72dd05fc5f550fa4e2f45aa4bd2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2dae43c977d9366512efa00ec27b609c697507a3ab00bf5fc282fe059db431a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "448e02cc325e4961eb084ed66987216be1addf78d54f132f859438406c6c58d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "aed13c5c6036b79fb0049581232236ca190596c2396731bf154d9f1356d03eee"
    sha256 cellar: :any_skip_relocation, ventura:       "89c326809971dd29e3ecf84cfc09b269453befe71d4cd0f7f50de9a0296370cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f3796092e6fdf92d15e0c1f4e1913a145839259cd5f5df7964e3434a4487eea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "494b579351d9dce7dbce9230739d619441e9b238476c8efb5cd85f0379ac4daf"
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