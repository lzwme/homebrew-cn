class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2024-12-16",
       revision: "27e824fad4cb40f9e475757871e7d259d73f20da"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a13ad96b76fd618ef74c5eadad35e5680b2c674add634fa74130f94dd8b2b86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2aac2c178236b1eaf4eedb410d11b8a7842a4de3b32d9d1d5a4a492b03c134f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec639dcc64878672d0a47e8a23b94f3b3132a7751f3b056fb3963c82c97e90c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc2267a8554a41de411d8a6816d28f73bff8fa25257087d20a51ae5c474233d1"
    sha256 cellar: :any_skip_relocation, ventura:       "bb348766a1713728f3b9ba983ccca1906e1cafe45ce47d3ecb0ca6fef06d3f35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14dffe55618d8579c6139689e5a2a403eae13f340b37089de0713d89160274c9"
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