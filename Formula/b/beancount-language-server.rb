class BeancountLanguageServer < Formula
  desc "Language server for beancount files"
  homepage "https://github.com/polarmutex/beancount-language-server"
  url "https://ghfast.top/https://github.com/polarmutex/beancount-language-server/archive/refs/tags/1.5.0.tar.gz"
  sha256 "9fa5fc1bb29b856583984570183731501c0e338e4deacf1d7de0f02bcd218df0"
  license "MIT"
  head "https://github.com/polarmutex/beancount-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61b83acf91f7b01f3145bfae9023c62c4d7b09441682a1ba1aba2850f8789612"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d67c99ff6cddad3a12bf6bf6a36f6d90a27fd32d1bc5e13c615892c97ca1eb75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9ce7db815fa36affb46ee900e3156db144a32fb65f8e574cdaf2442f0a80685"
    sha256 cellar: :any_skip_relocation, sonoma:        "58b9a42ada5f32908b6486462ce694739079b4af9d62bd6161b56fa7997dd8be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "548a127a2b481a181580fe437cb9061132b3469d96d1c7318ce0043f5db28855"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89d8a117c7634b8644ab06cd7ce8162ce38c8db162ce00b9a13170ae74eaffe5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/lsp")
  end

  test do
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

    Open3.popen3(bin/"beancount-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end

    assert_match version.to_s, shell_output("#{bin}/beancount-language-server --version")
  end
end