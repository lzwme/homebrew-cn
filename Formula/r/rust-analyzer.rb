class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2024-06-17",
       revision: "6b8b8ff4c56118ddee6c531cde06add1aad4a6af"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3bad9aca8d231555545557c7f2ddf92d513d0aeb68c483680258ff3f22c84044"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2f6d443d9c954e92bcb7f4f2d1de88854d99082a02e59dab263a80dd55dd8fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3168625bfa02b790a219716fa49dd6d729dd0d86b0db36a32ac208ee5244216e"
    sha256 cellar: :any_skip_relocation, sonoma:         "b01726c8c749f51997f6b5342b06c12d36301f1233a5b74fac55ddc4f71bb0a7"
    sha256 cellar: :any_skip_relocation, ventura:        "9efc5b36992b39f4f41eeb9fe12c2fd9a16575a052337827f0c622b2eb8152ce"
    sha256 cellar: :any_skip_relocation, monterey:       "f010dfbc01732c21fe49916e455857c27db63763d45892bf6c6e689dbe37ce69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbae3ecf108c5c263635ec8cbccd8bfb1c0d49b6eca06e09d5046a40bbb26a6d"
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