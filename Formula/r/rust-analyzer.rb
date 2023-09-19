class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-09-18",
       revision: "05666441bafd6010787a4097a6bd44266ad21018"
  version "2023-09-18"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a296f8475fa4fff880152b7d5f4c01f5baac52965f1e6b4c866b262b68bd74d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb4922248b6e91cfdb804c3053cb241d0cf1d6fe35b8cb948798d2a98116332e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "167eaa3635911e1680bd8781dbfba1123392721a6cd587896db7c6e189fccbf5"
    sha256 cellar: :any_skip_relocation, ventura:        "d98e9b127ed9655456c542d971f67a309ab9a829575c4f142e2e8627edd8ebe0"
    sha256 cellar: :any_skip_relocation, monterey:       "563e038290b1fcfa60d6178310dbc6c3f5fda7f03bd256c31f9361b367e9594a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5975e597fc2e5838561a5ec88673dbd47fb8a4d4c663300f6eaa1d8c35170a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0269a685a103d0379bbc8d0e45f5a9fef5332263be941fcb3d2b685f138b91b"
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