class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-11-13",
       revision: "416e9c856a792ce2214c449677ca0a1f38965248"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1b235c5fc89ad432c983f855fc62e2fae10b0e54194567d9ed18b488908de71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4acd00cf21629139e47a81716194047d7bc5c902582abd78a401eba39d4a39d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4235c7cba3d9899d1fca61061d21fc605280718a42507de7b14a7c1daccc6f72"
    sha256 cellar: :any_skip_relocation, sonoma:         "3caa4f468dc9710704481d06f5c1bf58869c8275c8caf2fd9c58584b01528428"
    sha256 cellar: :any_skip_relocation, ventura:        "489896a9f4a2782041263eb1e4bc51b3247ff04ca6756f0a782c16ae8961f68b"
    sha256 cellar: :any_skip_relocation, monterey:       "ce911cddd097f8de21f36c9eebd6fa997d945082a693d1fec939747594b18543"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c8a13f1a3113bec5e6420fa9f4107b6714296c86544b73f22560e1e478b690f"
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