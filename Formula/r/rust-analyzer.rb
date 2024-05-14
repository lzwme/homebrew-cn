class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2024-05-13",
       revision: "5bf2f85c8054d80424899fa581db1b192230efb5"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53292181d8e196c79ca9d14b93d8810d6a4245d2733982b6d731ac480f76c275"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fda450eebc9a1795911431baa9675c43c9ec247d1d5ee5481a6e9ea1130342ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39d6a344ba4e8635b0e5b646fd858f0537b5ca9f2ef723f3ee97f66ea53e4822"
    sha256 cellar: :any_skip_relocation, sonoma:         "fabac5c6c22b4860ef8e393c20963bb5eb7f4f626841a721de71cb2870cdbf37"
    sha256 cellar: :any_skip_relocation, ventura:        "74e3e12bda975311a87559153fd819a6c00aef6a3997a1aa3a0b049cb8c2ac32"
    sha256 cellar: :any_skip_relocation, monterey:       "85cc8feb8087829d077678cfc8d30c16d6f7b2eef6e67ddd5b1af9ee8f8174f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24c47e422f2ec4e82cc8cb46605908a4adf4a81f6503f605d018dbdea628fd4e"
  end

  depends_on "rust" => :build

  def install
    cd "cratesrust-analyzer" do
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
        "rootUri": "file:devnull",
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

    output = Content-Length: \d+\r\n\r\n

    assert_match output, pipe_output("#{bin}rust-analyzer", input, 0)
  end
end