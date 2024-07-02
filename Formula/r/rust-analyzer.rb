class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2024-07-01",
       revision: "ea7fdada6a0940b239ddbde2048a4d7dac1efe1e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f6467775ad370f5e9ef6315077b5628996a6cca6241ea6e9b978c8350cd325e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "790145b0a598145ea437a54b35d4056378773b451f48463e0079bdf4b2415e41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50ea4c22e98388f3369d58e7a6d1f7ff8ab99bd210aff0a41e4ccbdb73e3e6ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "448b36decc9df920ad3607e0cd5dfea51116cd63be7377bd68dd988afd02e9ec"
    sha256 cellar: :any_skip_relocation, ventura:        "4226d4766ffd3f6ba73ef27f787ffcfe722b184a0b4378b9d5833b03ebb3f46a"
    sha256 cellar: :any_skip_relocation, monterey:       "7dd885d2e6f2e12330d8835c9443d529c2b7e1d888a045305324a693af135e1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a71e5da688f6015cb3b80579c76bd26e1c20f1ce89ae3f7aef072584cf1d714d"
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