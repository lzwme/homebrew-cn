class Expert < Formula
  desc "Official Elixir Language Server Protocol implementation"
  homepage "https://expert-lsp.org"
  url "https://ghfast.top/https://github.com/expert-lsp/expert/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "69608d25f0a214e4360dbbac155e61729db96a1073e2e92b3b34a200d9cc26b8"
  license "Apache-2.0"
  head "https://github.com/expert-lsp/expert.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9acd897b4c38ed5de3f84e949a01450c3e9e17b6a86a833189c94aac2701972d"
    sha256 cellar: :any,                 arm64_sequoia: "042b471de1b653656c801463e45ac18ae2d9afd45082bb872a4d21e88faefd6a"
    sha256 cellar: :any,                 arm64_sonoma:  "3540b346df247cefe80a24566b65847876ecfc5ae3ae089b2605a0f24316bd62"
    sha256 cellar: :any,                 sonoma:        "2dc17156ddb089f8a6883c60d2095f6a5cb4b3e8868f0fc57b19e641e93590e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e09a8d592a45a221c73cdde76468a004b73a41c059c8aac55d332e471c5f842"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e87dbae846e59f49387826fc170b1d4ca2ebb0a4b18a9a67eae83a5b3e94096e"
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