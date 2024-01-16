class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2024-01-15",
       revision: "9d8889cdfcc3aa0302353fc988ed21ff9bc9925c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6432861b8be22adb5fdbf9140c51f121faeb9f4ecdee925e0d6e2ec989bddb83"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10c05aa832643ea8eb6bc7644aab94423ee4185197f1bd8b3e03608f84a27558"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39d76ceb725dbd19469e383a934dbfc98ed726d10bb9f369d53b38bac805809e"
    sha256 cellar: :any_skip_relocation, sonoma:         "b41a1801d0be54a57d1323ef1736479bab1daa91c02907e2715eaf45ba2cf484"
    sha256 cellar: :any_skip_relocation, ventura:        "51d7e57b498dae4cb8049f397ae3ff8a8978793f2c2d4f6fa9371d1c698eebcd"
    sha256 cellar: :any_skip_relocation, monterey:       "b3c593c5c31920b40109cc42f8fe5a20698cc97bcb27ef5eeacc97bd3dac114f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d941a8072e65dbab8b017f95974bcff41c9da88a9a73832096699547d764512"
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