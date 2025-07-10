class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2025-07-09",
      revision: "e429bac8793c24a99b643c4813ece813901c8c79"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "351a90b0855e9249088133b8e4b519c29caa59144ca765f8e5fa413e122b1b90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f29848e3b98b71b8b9819a47b69427c0f03cfb074badb6afa1128ef29b001f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "648f77071d0fb1b1c36e5f2bc154f274ec44546bfd81b327faf51e4cc0bf386a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d86d355df3db8e6b7020b792a622133f200d7c00bbfe95fd06c2f53f813e2520"
    sha256 cellar: :any_skip_relocation, ventura:       "4c1194665aaee693a97390a6646b13ff0d71fd74c56bbc16d13514483db8f04e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b218e1400d18f5c7710aa0115eb144b50539718a8e27c5d218aab59b737d01c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9dd5acbbc264a7f1192d4ff6a1ee3115c1ae9fb6cc6f4624e7e20f38a2bb133f"
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