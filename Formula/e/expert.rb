class Expert < Formula
  desc "Official Elixir Language Server Protocol implementation"
  homepage "https://expert-lsp.org"
  url "https://ghfast.top/https://github.com/expert-lsp/expert/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "af65f7172e2ba54fe19064c8dea9c38619d50bd70a97961ae826a3c4d3bc378f"
  license "Apache-2.0"
  revision 1
  head "https://github.com/expert-lsp/expert.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "74af20ae4d17e8842f7212077225feb4976a942b95a8eb8976c8772497184429"
    sha256 cellar: :any, arm64_tahoe:       "159358ec9792598243a01cd3fa900ede214c2836b9fb168f7eae00b9a2a34241"
    sha256 cellar: :any, arm64_sequoia:     "cce840479721041225109fca581e240fd38ef2a7f5842e2b9c917454292f476e"
    sha256 cellar: :any, arm64_linux:       "a972254509903e74d30ec51911c07fc6be6b6cbf576695bdbc4c6374dfd695be"
    sha256 cellar: :any, x86_64_linux:      "3e25ee773156f96336203423365b6b581d4ec3c86d43d9c6356089582e2776d1"
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

    # Use brewed ca-certificates PEM file instead of the bundled copy
    cacerts = libexec.glob("expert/lib/*/priv/engine_source/apps/engine/deps/castore/priv/cacerts.pem").fetch(0)
    rm cacerts
    cacerts.make_relative_symlink Formula["openssl@4"].pkgetc/"cert.pem"
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