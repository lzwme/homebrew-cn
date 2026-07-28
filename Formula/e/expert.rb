class Expert < Formula
  desc "Official Elixir Language Server Protocol implementation"
  homepage "https://expert-lsp.org"
  url "https://ghfast.top/https://github.com/expert-lsp/expert/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "22069974749142bed2194bebb4c3117055dc9ee3fe79fcbb256f1b11ac1ceb7b"
  license "Apache-2.0"
  head "https://github.com/expert-lsp/expert.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6f3d287cda67a6a896387bfe868993378ae8eaa537029b1a774b95fda446977f"
    sha256 cellar: :any, arm64_sequoia: "b2160b3c790a67ec98e8999fcb8e6213573d99b089facc64c31ad1b7828c919a"
    sha256 cellar: :any, arm64_sonoma:  "bc272160faffee2d278fae7343eeec329b888db0c4fc2805a65663024e2da355"
    sha256 cellar: :any, sonoma:        "b8585c5626417c9ab9e9abfc59c5f6d1b1cb437dec3a0966c5a7c71e1eff2a42"
    sha256 cellar: :any, arm64_linux:   "1de951f2a279c8ad4fbc2c717dbee16ce4beb8ecd64617d5782ae5c10741b721"
    sha256 cellar: :any, x86_64_linux:  "8296c74d583fc5e8ddca6a2a2356f3e40c159bc6656f4b08f1be9a146883b9d1"
  end

  depends_on "elixir" => :build
  depends_on "erlang" => :build
  depends_on "just" => :build
  depends_on "openssl@3"

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