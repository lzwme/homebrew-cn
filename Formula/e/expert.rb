class Expert < Formula
  desc "Official Elixir Language Server Protocol implementation"
  homepage "https://expert-lsp.org"
  url "https://ghfast.top/https://github.com/expert-lsp/expert/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "029d662b679af3f87f3f6e72ca9da4929134b8fa1056c4157374ce81c3f4a3a4"
  license "Apache-2.0"
  head "https://github.com/expert-lsp/expert.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1d2a6fc7b4ad5bb84200ded79a4af59a2ff5b70cebcb10d77ca287ec610efa08"
    sha256 cellar: :any, arm64_sequoia: "7348fc79dbd9037e28c7faacbe8025c39f590eccd47cc8010f36332092e3a6f4"
    sha256 cellar: :any, arm64_sonoma:  "af40e4837d2e4f60effedb65f06c743bfef202347732d869e700c727b3aebe0a"
    sha256 cellar: :any, sonoma:        "9c3f094dc43ac72b36092ad68d208dc5a498f49e214f50cebfcf140feb104e81"
    sha256 cellar: :any, arm64_linux:   "7ed6aadab171d2ee8f3c2e3277cb2fb43dc6e2485ffb39d6ded60c30c76da3b6"
    sha256 cellar: :any, x86_64_linux:  "6acdbae90ff3ae18f861b9c7ac286e3307fa1572f71af65f9d019be79b24ec08"
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

    # Drop wx/observer to avoid pulling wxwidgets/mesa/llvm; see https://github.com/expert-lsp/expert/issues/786
    inreplace "apps/expert/mix.exs", ", :wx, :observer,", ","

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