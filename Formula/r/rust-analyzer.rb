class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
      tag:      "2025-05-19",
      revision: "e464ff8c755c6e12540a45b83274ec4de4829191"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d636639c4c1e86754e1803d546500a381c31d4dc3ffc0e686060538cc02695e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbccd1da360b18d6351262c22d17d17e9c6c6b0bcea7d32397a9c90782e37943"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2684957f164d8a99300b866df25fb764ea6cb38a5134266f3b4b23265cd1602a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e0c8e3a99325dc36cb118c4ad9333fc7b450c6fadec565d42c9df7b2671ea6a"
    sha256 cellar: :any_skip_relocation, ventura:       "3da9616bb778659944b7a592746aa312823c39484a811c3397306eb0be3a522d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2a603bd2ca7e513bd4ac6ba2cc6b43042e2b08ad4bf2dbeaf1e93477c88c88a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "019ff51c5964f62714e3a75964e78c97341c0f9a2f668f8c01d7a4ec0d7f1bd5"
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