class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https:github.comclojure-lspclojure-lsp"
  url "https:github.comclojure-lspclojure-lspreleasesdownload2025.05.27-13.56.57clojure-lsp-standalone.jar"
  version "2025.05.27-13.56.57"
  sha256 "088972f1eb9fb88fc436089a98a7e19c57bed1db2c0ca125e0c60325fe129bf9"
  license "MIT"
  version_scheme 1
  head "https:github.comclojure-lspclojure-lsp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d{4}(?:[.-]\d+)+)$i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3d619401724cbfdd92f76cd94d934055b4bc3c94878d8f34ada1bb77bef9b649"
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