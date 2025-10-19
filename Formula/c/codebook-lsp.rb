class CodebookLsp < Formula
  desc "Code-aware spell checker language server"
  homepage "https://github.com/blopker/codebook"
  url "https://ghfast.top/https://github.com/blopker/codebook/archive/refs/tags/v0.3.15.tar.gz"
  sha256 "54cb3f82eabf023036f3f2a3ad931af970fc1b318c5d5ca15da9f183182db502"
  license "MIT"
  head "https://github.com/blopker/codebook.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "763a13906e4d2570093a815f8edffda9e8e0bbae0932c0e77d6ef07191e81085"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "388bbcdefb0ce4cf223833daceca26ffc923dd068113a6ddbd2e81022bd311e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0ae6cab8ccde7f8fb7a5a3ef2e96b267faaae1d6ea1dd8b4328b6fb91a9f23b"
    sha256 cellar: :any_skip_relocation, sonoma:        "31871c4db631deeff210adc14224c35003a4235d635739092b9ba6f6d383955c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c73c858df05c277b678d2ce332d3536e60b3268349c9b969071a5b54afa6624"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7887188507e8231bc9f94ec9281c3610b9c1495e1aa91ff2ffaa0bd52883415"
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