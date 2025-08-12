class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2025-08-11",
      revision: "4e147e787987fdb1baf081bd5c60bedfb0aabe16"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a03f10baaf92718b603abcd04f3e467cc1ef0a95b84ae62ab699b4a7ab212ef6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2ed394657227f5cf67d37a7e0823a2ecafd187304df1566ba3c21f75e23d1c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ff2811825adba4f43ccdec9f2720aa634b867e2809df33e763cd7328723a06b"
    sha256 cellar: :any_skip_relocation, sonoma:        "471b6d403cea4e13f9f6b50963e20343b05ebd9885d1780f34c2b2a5cb64b41d"
    sha256 cellar: :any_skip_relocation, ventura:       "a5af8d749276a755f0b41861c302b183cf0f57aaeee7ede00d36c5b1dbaaecd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6a40f3c255fd0433ff021e0d52404bd7270febde13a3c07cd6db0045c1aa3c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f27bfcc97378a2ad47973637c80264384a36547dcd92513e739c37d505cbf64"
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