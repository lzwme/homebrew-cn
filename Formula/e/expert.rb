class Expert < Formula
  desc "Official Elixir Language Server Protocol implementation"
  homepage "https://expert-lsp.org"
  url "https://ghfast.top/https://github.com/expert-lsp/expert/archive/refs/tags/v0.1.10.tar.gz"
  sha256 "18fa9533a7d43d5cff52ba1ea687eee9b69adc599ae84ab9fec54d813c23e31c"
  license "Apache-2.0"
  head "https://github.com/expert-lsp/expert.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "e0480b346a6a454c5963848dac3048d915c82bd5c111b64df6435f1a467c79b8"
    sha256 cellar: :any, arm64_tahoe:       "67ca5acb4680f4eafb61ddfca2d540f19d6558a30da6d5542cc64f2cba11d5b0"
    sha256 cellar: :any, arm64_sequoia:     "c33f76ec4c4597e85c848a0a4d5226e27c5a30bac667224d082303e30d373633"
    sha256 cellar: :any, arm64_linux:       "bc0265d564a656bb5a3e2c05a92852cf50a51020e113baffa82bedc39e405c93"
    sha256 cellar: :any, x86_64_linux:      "ab06d5928ef83c23bb47fa0ff09ef32d37f5eaf2b4deda42e359ca847f16b76d"
  end

  depends_on "elixir" => :build
  depends_on "erlang" => :build
  depends_on "just" => :build
  depends_on "openssl@4"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "mix", "local.hex", "--force", "--if-missing"
    system "mix", "local.rebar", "--force", "--if-missing"

    system "just", "install", "--prefix=#{prefix}"
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

    Open3.popen3(bin/"expert", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end