class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-09-07",
      revision: "9074e9b4c6bc31d7986ccf4e22d18af70e5508da"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eb7e3fa7394da2c97f92e8761bd18d95793c450203be054ad2f4b807b610b6ed"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d0542a8174973b77c1d18412e442a558d9de251e97d8db20f6eb7b28818338dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "44d88dfdf6dbc62ad51a2508245275d2fb0adfec884bdbf16df2cba93614ed9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "4edc5039f7397c8e634bd4187aa42a91a0b0a89a75c1ac8e447b509ef49820c7"
    sha256 cellar: :any,                 arm64_linux:       "4360f83217571940149c91973e303c32513b352a99f8dad19f867ca9bb53281a"
    sha256 cellar: :any,                 x86_64_linux:      "669b33da769ed0eeafc0c5fbd61a00f8fa48d4132ca41e8e694072826e60ea21"
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