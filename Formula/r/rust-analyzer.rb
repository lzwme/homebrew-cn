class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2025-08-04",
      revision: "8d75311400a108d7ffe17dc9c38182c566952e6e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c27b07fc5d68728c4fc29ece0e1dfacf323276e8b6ba1e431fe4b1d0a39371f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "086771f6e9519f47b674c590768a8e6f220a088f8e760ae9911b6ca7f22f0cc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d2db5310032b06f2d87b1abcf46fdee520090d1b44ad6a6c95600a7001f7b7b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d97d03f7fbd79295efeaf2a8150dacfb05b04bf94994e403b09efab95b34974"
    sha256 cellar: :any_skip_relocation, ventura:       "8015f2e0bdbba94a0a70c50c049c57412f5da34572c47d2e5653dddce038cf26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20ec46190e8ed89dc3ac46f4e36997d77b32615c4b88edc63b85cf189086670d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4636330f6c00621472e0dd35dd257256fc5c1c4790012b22a47ef6a6c8ff6498"
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