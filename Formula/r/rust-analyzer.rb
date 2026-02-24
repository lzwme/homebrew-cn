class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-02-23",
      revision: "0c746f699034e70e1c3f11036b8c2895a0b1071c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "032cde591bdfb93f817f21c31dc04e464f6712b9f7138fabc8dccb3baaccd197"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d33d332272bfe94c61181b9ba95eafee654985fe7775da91cfeed9470fdcbe19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb1013297a4aedda72eae68f0c46e03618e45e4de2c40e8a130893c80bd2fbb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "c76ba08bc9d62605630e850d182f3b6d2e599636c804654abb7266e7aca53aff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09f898c71d1137b4d8f960a833b6bc2b53b45553c7aadac11e80649f788007fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cfe40f21ce7e18bf91ddf520e63230b2fa0b920a0de147ab71826843a507a27"
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
    input = rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id":1,
        "method":"initialize",
        "params": {
          "rootUri": "file:/dev/null",
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

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output(bin/"rust-analyzer", input, 0)
  end
end