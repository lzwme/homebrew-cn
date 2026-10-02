class Expert < Formula
  desc "Official Elixir Language Server Protocol implementation"
  homepage "https://expert-lsp.org"
  url "https://ghfast.top/https://github.com/expert-lsp/expert/archive/refs/tags/v0.1.11.tar.gz"
  sha256 "8784b2e26cbd4c512459278239659a855d3f074a7dea93310ab299b1d19378f2"
  license "Apache-2.0"
  head "https://github.com/expert-lsp/expert.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f4efd5a46350b9c9e7a7aea1d86bdc38ae242f36914025f8d5f72cfeac093c83"
    sha256 cellar: :any, arm64_tahoe:       "6242dbe156e9d1aab3753c614e8cd999c356385ff9d382de4ddf11d95ce5a1bd"
    sha256 cellar: :any, arm64_sequoia:     "24aaf88ef24a590b9f4601e66476d5c1d5b7ad35c66c077c6ca7685a3a2ac0c2"
    sha256 cellar: :any, arm64_linux:       "c7d0a0fb9294dafe4005fd71aec987e80a4c67337917f78fc12512386e6f71bc"
    sha256 cellar: :any, x86_64_linux:      "3fb57d0c964b46703a1f47ae72d30b89be4ff2c7bb8b99cb075db37bae3b3a71"
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