class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-04-04",
       revision: "236576227a299fd19ba836b1834ab50c948af994"
  version "2023-04-04"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3eb77a7566a2a57589229357637a74c4f436bf82ec88c8daf20695013a017d25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c4deeff447495c69a539e0c2bd61e9461338410bf263f4fb8b6cda5a48e9ada"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7cb80f0dc71c4d493b0f2b00700f063dc1e4be60a38451e4545c95e117d798f"
    sha256 cellar: :any_skip_relocation, ventura:        "51c121f8a1cf2748a4048420124ea0bcfd36310f7745273a1978207b8246606f"
    sha256 cellar: :any_skip_relocation, monterey:       "8086fe7cf1f655bdb686b99da75428a73d90fd75f71bf329c6469c4f47722714"
    sha256 cellar: :any_skip_relocation, big_sur:        "bffb58129cf8c1c82c8d5d377f60739d5ad6fd774eb221ec8138d3c782079c5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a235f94859c6ffe2862d2152a34076cf7fc813c41de3a2ee3707d8e6653b194"
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