class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https:github.comclojure-lspclojure-lsp"
  url "https:github.comclojure-lspclojure-lspreleasesdownload2025.06.06-19.04.49clojure-lsp-standalone.jar"
  version "2025.06.06-19.04.49"
  sha256 "3220b0aa582f03dbbae05b3892426d6b7e20b6c6a9c9e95b5346deffd50126c9"
  license "MIT"
  version_scheme 1
  head "https:github.comclojure-lspclojure-lsp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d{4}(?:[.-]\d+)+)$i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bb3cb3102608aa2d35dddb86d1bc0abfb2e6eeae3b99af10dd7878a75bc81b03"
  end

  depends_on "openjdk"

  def install
    libexec.install "clojure-lsp-standalone.jar"
    bin.write_jar_script libexec"clojure-lsp-standalone.jar", "clojure-lsp"
  end

  test do
    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "processId": 88075,
          "rootUri": null,
          "capabilities": {},
          "trace": "verbose",
          "workspaceFolders": null
        }
      }
    JSON

    Open3.popen3(bin"clojure-lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(^Content-Length: \d+i, stdout.readline)
    end
  end
end