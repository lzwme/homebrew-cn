class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-07-13",
      revision: "ffcdbbd9066218089aaf0d428d5bf51cadcbcf48"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57d575660278ea356e9dcfd8a17c299bae7e7d2d1054f17089075859ed89a034"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90c6b88543486503032e8406061ba4da04bb83554cf3b982228e82fbec88db20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "205a1b9e38f479708aa728b33b66cd794807389b8f1701bfe0f2b992bdd8f924"
    sha256 cellar: :any_skip_relocation, sonoma:        "dac913996fd96a86e7babcc8cdc15ee9cb860dd29dd9e56a716831a6bcbe9e5e"
    sha256 cellar: :any,                 arm64_linux:   "276f1b26cdfae1d33c04df7503c7062e41f9f47fbcc442c14ac5654bcd998307"
    sha256 cellar: :any,                 x86_64_linux:  "c367aff70e98b150acdd3702adfbedb303309b5cc6e420f3eab88f0c62f8b2a4"
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