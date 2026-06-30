class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-06-29",
      revision: "972c4e7bee140acd27e26b3e04673bfd05302f89"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b4378548f589bb0121594c44de625055a37b4a677f8a6a00cd85978d4744fcb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "295b948d83bed4985187fd1f8b8daed1ce612c7ad1c8893b9a4006aa91c1c4ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93de84e22984ca7df30e1ed4650dac25f4c003bdba72ac6855daaa4e6da840fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "b18b1850e49f67908a3c844693bfb0cf80eaadbaf7158279770a75ac83ba1a48"
    sha256 cellar: :any,                 arm64_linux:   "a629f89d1d565af06a254121c46076ed06095274dae374198e32c33b73f6e120"
    sha256 cellar: :any,                 x86_64_linux:  "24dffd8e1892c0c27e31ef55e1a006cb3ba550054df279f0d18c7a633bcbb341"
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