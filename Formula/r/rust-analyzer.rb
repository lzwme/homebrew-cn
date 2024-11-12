class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2024-11-11",
       revision: "30e71b609b493897ed81f4fec95eb75d903820c9"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c07cadc8b120781222b8419a251c33978bc366f94edd726b05896b64c0007076"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e3c4b5365e3b108c117a8b7ac9079dc2980162b6dd96524dfcd8d1fd6f79b93"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d011637ff013bca86dd8f4e99577b2805f8dc2fcbe789d7b7570c7a97b2e41c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bdf79ea7c9de1adb61faa6e27d7c4c67bf66bf14078ee01262d25c2d483b3a9"
    sha256 cellar: :any_skip_relocation, ventura:       "bcd4576ba6969b86f31cda21d0414b5a1a8869aea4ddd09452d1be9682d6b343"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7af6a559af0c417f92795bb701ab7e29ed1ae8eaede92bda2e3b5ac47e5b4cd"
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