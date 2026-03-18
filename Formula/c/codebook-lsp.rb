class CodebookLsp < Formula
  desc "Code-aware spell checker language server"
  homepage "https://github.com/blopker/codebook"
  url "https://ghfast.top/https://github.com/blopker/codebook/archive/refs/tags/v0.3.34.tar.gz"
  sha256 "8a8943ca8e6bcf8aa479012b1d043f9a4211929d0dcc043ba6e618319a5aad80"
  license "MIT"
  head "https://github.com/blopker/codebook.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcac29a286402fc32c0859ce980583939d9ea01ca45f5bfaf8b8bdf0bfb11225"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3725fb7063d0148e96c1426efa3b988be6eabc2f735b7a87e65a2035e3eab8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2208cb44eb1d1beadd529cbd8cfd9a395e94090fab1a9609f5d1275c3a30897e"
    sha256 cellar: :any_skip_relocation, sonoma:        "919d21c058ddc6a71d543084f926277acf0c1a5fc42b305ead56f0dd035799c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "281d67363a392c98e66898654c3a57b7aa1fbe2a1d7914b1c38948a0ec488ed6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c04ebedccbe4157edc047ba320b2488359d115fae6b6ae9b19ca3693f059cde3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/codebook-lsp")
  end

  test do
    assert_match "codebook-lsp #{version}", shell_output("#{bin}/codebook-lsp --version")
    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3(bin/"codebook-lsp", "serve") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 1
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end