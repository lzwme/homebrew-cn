class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-10-23",
       revision: "10872952c03947124f8ccda7d7aa7930b7da32fe"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d8e0efac6c46dca7fbee0d59ea85fe55466a1bfcce44eb82eaeb4d763c841e6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe5124b3286ddcb794d6e3898664a25efdb0094d2f506f1e1bcd3bdcef7cb36e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d49a6dd5dd41b01ed3a64654308f95027c5895dca1bb5efd153ad255589a725"
    sha256 cellar: :any_skip_relocation, sonoma:         "c1cd154c1442aff11038bbe3c0b91f5a8499d2a15c93f3dd0c03b7c64c93e295"
    sha256 cellar: :any_skip_relocation, ventura:        "92cb59a78aebc4aff72899b9612c9df3d28fecafdcdf52bed7ef5b259724c6a3"
    sha256 cellar: :any_skip_relocation, monterey:       "b4b13f029741aef91fa9dd6a2f1ef01b564cfeb22a3ab02883dada55f305ea5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe0f6e49e9e6ff2914507b56012c9f7e96ec0d63e2132741b7872ec522c893fb"
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
    input = rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id":1,
      "method":"initialize",
      "params": {
        "rootUri": "file:/dev/null",
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

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output("#{bin}/rust-analyzer", input, 0)
  end
end