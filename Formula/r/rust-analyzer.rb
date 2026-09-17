class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-09-14",
      revision: "682a84e95b5a52cf06e9822fcaa4f628738554bf"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "72d78b065466d4defee0e7d82f277860d34f1ab4bc02b7d596aa43db796fb437"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cb99f52b4e37b7ae641626b7ad2649cf07c047feb8200cb328fdadcf64e30a94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8c1edda086da91a10914f5c7a17ce9a3ace0a24d14d4bd864b78f588055e2f25"
    sha256 cellar: :any,                 arm64_linux:       "eee538f7ca77345bed602b1002386dd033507ad099f95567ed0186f5edfa15da"
    sha256 cellar: :any,                 x86_64_linux:      "1cd83718cc95d2c3950744f717af549faf223edad2979851234ca3964c56d88d"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

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