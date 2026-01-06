class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-01-05",
      revision: "6a1246b69ca761480b9278df019f717b549cface"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b0ecd9b41b9586abe6e5d161dfb6cd93e4f88071bad57c5d5863e1d4ae97e2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec3fc498b1731218d76974ed9fddacf98a44d0370f0f608a64b2a62ac0cd79b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9944cfe1cfc9bb98443b4de2ca1fae46fba86dc23bd9f38e4d5e1ec6b8cb9967"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fc8504494093c737854303b462327ff90da114fff554743a43083792f3b023a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7bf82b4990fdc56324465990af181ddcf5d1b9a49375160be38844b59a4a671"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "baca78fd642e7516d19ce79c3641b610a9befce547aec6f6e3088202a3e8ea15"
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