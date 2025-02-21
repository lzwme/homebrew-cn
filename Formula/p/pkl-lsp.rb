class PklLsp < Formula
  desc "Language server for Pkl"
  homepage "https:pkl-lang.orglspcurrentindex.html"
  url "https:github.comapplepkl-lspreleasesdownload0.1.2pkl-lsp-0.1.2.jar"
  sha256 "7f9b96be74a3abcec2b770d69ca2b215d8684c311d79b414b59f84784cb4b6a5"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "909fbb43ab9445b1b8b31a1846e55d4ad105cf0912f3a21e3c19dabb654a991b"
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