class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2025-07-07",
      revision: "0ac65592a833bf40238831dd10e15283d63c46d5"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc88f1280fc32bf373b3755f9fb1552d8d4b9c8c9fc7948a15fc4c79e01e6c75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16df5ffa8ef625059e88937afb99a193033c824c3372dfea4d68313a971116a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bed24a4b4f51240f64ee4fda74056132887b321f77fcb00d324e305fb0a5d56e"
    sha256 cellar: :any_skip_relocation, sonoma:        "58797c954cb1f73a60d72b41e1bbd5eb8e89dbc3e2302464e99890241fc9e5b4"
    sha256 cellar: :any_skip_relocation, ventura:       "c0b472e2ed746264640577e0455e7fb95f2c0929ea31bd40a4b5f0ca47a20594"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c22b76a73203dc533493b160bdeb869fe32be29a27fbd3d8533f1ef267d93fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee08897a4ba1b9e65d08b27528a62d184fc46317ebdb094cd70afde9efa02ec2"
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