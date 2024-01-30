class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2024-01-29",
       revision: "7219414e81810fd4d967136c4a0650523892c157"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ce390785a433d0e45909e616ccb81279b8ecf6b4ac406f8a5976aa989270846"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a03821317cc445a31d1094c7f17dc9c352fbf9e8d2f3c38e076662de49a1e0d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e31f3bc0b541a6e5e3b9d3f33c861dc495445964cecbc5ccb176eddb53b3bc77"
    sha256 cellar: :any_skip_relocation, sonoma:         "59db24386ccc689e7baa75cb23963c79cb56c12db6febbac98eaa743a33aa56f"
    sha256 cellar: :any_skip_relocation, ventura:        "33dc5f969a150387001cffeed21a409cc880238a061d8b42337fc8ee8a6cf294"
    sha256 cellar: :any_skip_relocation, monterey:       "e49511ded035d29438458617d0cf7d3bce07076780bfdca4a9fe11eff41b4241"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4156ea7a73b4759987448b8fac005a9bb37cc6fce2ea865d4ce1dd874f368c3"
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