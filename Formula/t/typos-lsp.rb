class TyposLsp < Formula
  desc "Language Server for typos-cli"
  homepage "https://github.com/tekumara/typos-lsp"
  url "https://ghfast.top/https://github.com/tekumara/typos-lsp/archive/refs/tags/v0.1.42.tar.gz"
  sha256 "296168e4e9d6db3c457ade75292f734450f65d19aa7c79e1751a7b09367c10b8"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "645ff1c4fbf3b0422cf166bf7b7e80d35d82e0be4dd5f72ec1e9d34b6fcc641a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1043495b2e3c4b428c0771a2818dfd550702f5aa3ef2a9dfe8090e244282e84b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "94a111110eb0736f409dc70db45cc992d7bb54fd171a7ec563d3c929ae4cd444"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3700831468628b54b14503084335a14838756b2470c5db23bb229bf2ffa0175"
    sha256 cellar: :any_skip_relocation, ventura:       "815ce7e124eff721ccf4e6768eefe85e850580da53a0b75d6472e74bfcc22576"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a71f5776b9ded0670dada2487f4bb2b66948c54d1740174439f2edda56d4339"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89ad9dc6d2a14ffe3bf9d0e48bc3a8b5230422758b0b191e0ca21c546fceed33"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-lsp")
  end

  test do
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
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output(bin/"typos-lsp", input)
    assert_match(/^Content-Length: \d+/i, output)
  end
end