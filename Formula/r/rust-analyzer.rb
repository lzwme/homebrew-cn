class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2024-01-08",
       revision: "af40101841c45aa75b56f4e9ca745369da8fb4ba"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "222d695b0b04ffd0a455faecd5f4ba4d8063020a20f6184c4ccddb203dfdb614"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1efaaf9b41c9aa37f9226d3469a1d75b92ddacf320528b78638d6cb19c0da89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39cade0d565a0db7915236038f4fc3bade4704d750e8577dd7f4c732b6a64de1"
    sha256 cellar: :any_skip_relocation, sonoma:         "fc3cae20ca663a3517edde61e38c924dfebf47bbb8fadd6bc3c816897977d94c"
    sha256 cellar: :any_skip_relocation, ventura:        "9251c7fd0e19f6cb784d55b81151515b6080d6c9004d25db21eb1e6f6b531f8e"
    sha256 cellar: :any_skip_relocation, monterey:       "115fef15ceed86466a78cf4f6ed7b4c2310640aa7437f0bc017eff8400266e93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61c1343355645bef1ddda434d08cae2999c7e7611ec21a9dd87543c02b436d49"
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