class PklLsp < Formula
  desc "Language server for Pkl"
  homepage "https:pkl-lang.orglspcurrentindex.html"
  url "https:github.comapplepkl-lspreleasesdownload0.3.0pkl-lsp-0.3.0.jar"
  sha256 "af459da9e2cb03bc0f28b95f2f0ddf9bb1de95db865642bbcc49a80ac241f912"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3f36bba7b502f14266076279273e86f7e1b4ccfa46ebbf54ca9b7e72adaeca5c"
  end

  depends_on "openjdk"

  def install
    libexec.install "pkl-lsp-#{version}.jar" => "pkl-lsp.jar"
    bin.write_jar_script libexec"pkl-lsp.jar", "pkl-lsp"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}pkl-lsp --version")

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

    Open3.popen3(bin"pkl-lsp") do |stdin, stdout, _, w|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      stdin.close
      sleep 1
      sleep 2 if OS.mac? && Hardware::CPU.intel?
      Process.kill("TERM", w.pid)
      assert_match(^Content-Length: \d+i, stdout.readline)
    end
  end
end