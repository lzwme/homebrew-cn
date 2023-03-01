class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://github.com/sigp/lighthouse"
  url "https://ghproxy.com/https://github.com/sigp/lighthouse/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "c8f007328e804bca78f057d6f4264666b6fc87f152d1173bc832af34f4b9e8b6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0577d01d009cc0653eab214e762cd0f33dd9174a1bf4a1d9268425d4f9b71856"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a1a942ed97c1df5ce8b08a573066b638680bb4e6a303290ac4c6849f675af61"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f8b0efb07d79290675be6585072e0e2aa426c0654d0242d18c24c6d1b1f338f"
    sha256 cellar: :any_skip_relocation, ventura:        "b79bd836cce25acb585308e71cf19405169d6823a15fdaf77f961fa8b437ba98"
    sha256 cellar: :any_skip_relocation, monterey:       "0b2989ba02e7fe2f4be23477729f86732f4e4bc650d2099522823c742bf9b1b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba8b886ef8449078833c50f473b48941d4ae4bd7abfbbacc0d5b5bfc7fd3e48f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e04ddeaeeca28fbe39354e5ff4f54872e53ea8de2972bd060d174497ee854285"
  end

  depends_on "cmake" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build
  uses_from_macos "zlib"

  def install
    ENV["PROTOC_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args(path: "./lighthouse")
  end

  test do
    assert_match "Lighthouse", shell_output("#{bin}/lighthouse --version")

    http_port = free_port
    fork do
      exec bin/"lighthouse", "beacon_node", "--http", "--http-port=#{http_port}", "--port=#{free_port}"
    end
    sleep 10

    output = shell_output("curl -sS -XGET http://127.0.0.1:#{http_port}/eth/v1/node/syncing")
    assert_match "is_syncing", output
  end
end