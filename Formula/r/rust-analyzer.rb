class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2025-12-22",
      revision: "9d58a93602913a1a2ecff29422eb4da67d304d9d"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1db03f8140ea0eb819e42fa5b053327d9b17130439d363c5e14bc7ba5f9f9234"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "260be4e33c6766dd1e21911ac701e7f8a10157e837868c37e2bd2859ad607994"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c3f22ad631d42e165611625e8ba6ebec41ac327d78158f696cbc8bc959297a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "70ef80c0d0967ea6599c4fba300a986875e3a2a184fd31061d32738ca0f32742"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bad78ef28b6d22e50ac25b8c6a15da163de6b2484a2c3527a0de0bbae8011208"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "468a9b35260b69a260237ed9b136d7b1a2d932ecc7186d2558d3073ea71605f8"
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