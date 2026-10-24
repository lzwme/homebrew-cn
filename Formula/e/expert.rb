class Expert < Formula
  desc "Official Elixir Language Server Protocol implementation"
  homepage "https://expert-lsp.org"
  url "https://ghfast.top/https://github.com/expert-lsp/expert/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "386b87925978899128fcd0282dbd7c8fb45698f378e1513d849d8b4a8920b486"
  license "Apache-2.0"
  head "https://github.com/expert-lsp/expert.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c076e5ede26b1a36a0bc701769bacd8e1d3d973968fe5db798ddd06b305f59ff"
    sha256 cellar: :any, arm64_tahoe:       "e32caa47eb8eb7080c1e634853e70308d170f66e9211b9e4a499848b5d15cd7b"
    sha256 cellar: :any, arm64_sequoia:     "ccae87aff3ac4eeb5d813fd6ee18e8fb8d6297a047845ed813b636d4c5244342"
    sha256 cellar: :any, arm64_linux:       "b6e7f0f90d76b78d71925b6032ee96b50a968734fcc42e4ec1e207d13f15b7e0"
    sha256 cellar: :any, x86_64_linux:      "8018721aa90a94da04e4e8a022686444593be857ddfba8972c2b1a16359dc785"
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