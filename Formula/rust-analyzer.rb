class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-07-17",
       revision: "d82451103962b1482cb137850c81a1acb34db0e7"
  version "2023-07-17"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db946d56fead6e702f2213fb084a94ffa0893302904bf6be1449abfccf82d6ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "329bdb330c3d34deb753e9675221ba7da2583ba087753710a9e24d661ab2d2e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0768ab25ebaa7c074fce73c32ce2be4ba4bf8faac7e3f2abf3eb2d321e4a993c"
    sha256 cellar: :any_skip_relocation, ventura:        "b2a668fa29586a4026a88de50e0ae8511761f4f77b1da0f3954f5e4aeece9407"
    sha256 cellar: :any_skip_relocation, monterey:       "383c7c34f7599c2f724635446d36782602ccc0d6e25757a6118d4f7ae42450fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "79d036f4327c27960d7675cf5e1a82bf36b7200c0dff209484588548a8abe4d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82dcfd4008733b3636d7c02bf271c833e49f5448b5a6dd6324877a0c59dbd79e"
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