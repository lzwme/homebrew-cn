class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
      tag:      "2025-05-12",
      revision: "2bafe9d96c6734aacfd49e115f6cf61e7adc68bc"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8d6d1ed5455cad6e18df2abd537d836d8dd6de852c532d093425134553cb48b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc304eca320b307923e48746c79823a35551d4d7990cf64024c918568db2427a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e9b9581e5bd92faadd9fce087a24bea7a886d5cd449ca2342196b3bc958253e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f42180708d838ad7d66e5cec8c4ba4771e9af0beb5a763365578c3d6e2db7985"
    sha256 cellar: :any_skip_relocation, ventura:       "465a2177ccac87be2ae92653c63ef0aa0aca68aff6819ab79d488b4a5c3ce6be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc177fd5a035a62adfb00d42da423b1ec2f475311bf0457edd37312c64aa84a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0f3e4601f073e487bbdf4daeebad57f40853be24150116299e1727c70e6774b"
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
    input = rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id":1,
        "method":"initialize",
        "params": {
          "rootUri": "file:devnull",
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

    output = Content-Length: \d+\r\n\r\n

    assert_match output, pipe_output(bin"rust-analyzer", input, 0)
  end
end