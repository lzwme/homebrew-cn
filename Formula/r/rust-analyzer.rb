class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2024-07-15",
       revision: "e9afba57a5a8780285f530172e3ceea1f9c7eff7"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e7a912068b32e2c9457cd159c973a367eba5334b6e3a95bab98c5bbf93d18ad6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77ff3fade4010192e41f6ced0735420f24be95a7644af9486d784d5351ba4a17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2ba00f0ee21f6815e9419966b2993eacadcd46eee9f835538f0160d79b7597b"
    sha256 cellar: :any_skip_relocation, sonoma:         "5521f845a5e941b46e47fa65d2d2f17f1b08669ffde767a1bb4f6324d96dc076"
    sha256 cellar: :any_skip_relocation, ventura:        "b057b3dfb38e1c0b60788f63286bbf157e7e6dba6798dc1e958d81e6836fac90"
    sha256 cellar: :any_skip_relocation, monterey:       "8fa61e0ffafb2abfbca5f64df03288f532176672e68c2eeb6acb5948652f2899"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80dfe4a5ead13db5510e779964c5dafd318d9ff601ac9ee03b9d44880ed86221"
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