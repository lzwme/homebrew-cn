class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2025-02-24",
       revision: "6d68c475c7aaf7534251182662456a4bf4216dfe"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1126bae45bd41a3f15c79c13fa0742519a7ba2ad68210bc003fe645c1a11ef7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c2944147e2fc1035da9fdeacf18e5532ef5b0ae25012d71064b8e588f7c611e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e26504e626d8dd0e2abce90c80e0740e77680b74e3b8fd1b776bf826ef254d04"
    sha256 cellar: :any_skip_relocation, sonoma:        "7592530632857534326148f86e33c2107a57ca914039edf965ea12304bd9a996"
    sha256 cellar: :any_skip_relocation, ventura:       "5880d5f67f3e1088f0d50578d6d82fc99de85991716b1c1799a3cce3053f49fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94c781953757580b3e4c97966c51c677aad8b8ef20a7be11681e23619218a913"
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
    input = rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id":1,
        "method":"initialize",
        "params": {
          "rootUri": "file:devnull",
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

    output = Content-Length: \d+\r\n\r\n

    assert_match output, pipe_output(bin"rust-analyzer", input, 0)
  end
end