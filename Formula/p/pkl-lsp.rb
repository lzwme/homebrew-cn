class PklLsp < Formula
  desc "Language server for Pkl"
  homepage "https://pkl-lang.org/lsp/current/index.html"
  url "https://ghfast.top/https://github.com/apple/pkl-lsp/releases/download/0.5.2/pkl-lsp-0.5.2.jar"
  sha256 "52b962cbc0eb871387596258bc13f502cf44cdf9fb8f437223f22891642e9dbb"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "17521ae021c450707b61adfba778306829492aa7c32680f2982aa5aacf45005b"
  end

  depends_on "openjdk"

  def install
    libexec.install "pkl-lsp-#{version}.jar" => "pkl-lsp.jar"
    bin.write_jar_script libexec/"pkl-lsp.jar", "pkl-lsp"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pkl-lsp --version")

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

    Open3.popen3(bin/"pkl-lsp") do |stdin, stdout, _, w|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      stdin.close
      sleep 1
      sleep 2 if OS.mac? && Hardware::CPU.intel?
      Process.kill("TERM", w.pid)
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end