class TyposLsp < Formula
  desc "Language Server for typos-cli"
  homepage "https://github.com/tekumara/typos-lsp"
  url "https://ghfast.top/https://github.com/tekumara/typos-lsp/archive/refs/tags/v0.1.41.tar.gz"
  sha256 "54182549823ba14d411d06b20a17765061f5393955a82a4cce3bf2b51ea7fe6b"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f951eb5530d894e3f20bfad6755279e4ae1ce27d74aa427e3359923e0d51a0d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1af75f5cd0151229f7b1001d8392b0218eb6d9211c1dc7cfba0c648f302626d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7fd10e761364e26fdb160b4723e3a50cafda95ad9bc571c4bbe3cd5e93bfa12"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9cac6c2843c916e7bc345a509144f47d431b031ed3c60afdf1a2c5b52b8cb8b"
    sha256 cellar: :any_skip_relocation, ventura:       "e1f895c7f59e9dcc5bd8015b31871e26bfdc37f0a26f2f4a697f928bd7467411"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdd9b9355dd0d9c1b8d6a88f276d8999ddc7a9e6132530ea7b5afaddf9c22893"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecdc2956da389b5f8cc12343a2e8f7182a146111727da2bf214cc422735e5a61"
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