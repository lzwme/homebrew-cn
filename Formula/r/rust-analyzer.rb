class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2024-04-01",
       revision: "e4a405f877efd820bef9c0e77a02494e47c17512"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "710198eefe9725ef91b4cf6512241162afb2c15d512ac94e2bd0ef66100e17f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1476a12db643bb320b29788a4e02d0cd49853811b6a327d0d55cc9a75c5c9288"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0980ed3e37b7a000f3d609a217216440f8a85f519b05a6c14f36911d5c86fc8"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ba17953b49e9445508a55d5f967b96b972616ccb4821db5913d17cb96362c2b"
    sha256 cellar: :any_skip_relocation, ventura:        "1797cd67f7f3e254006558829b36adba5b2dfbe708169e026af3e002343dd650"
    sha256 cellar: :any_skip_relocation, monterey:       "274eb58dedef3bb652e7b890d6c48729e5d915316c3e707c7acb8994446b22b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "260985901815f27c0b48c10acb4e40ae2ef7e5b2c6e51af5076b1d72b495eb9e"
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