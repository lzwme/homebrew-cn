class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https:github.comclojure-lspclojure-lsp"
  url "https:github.comclojure-lspclojure-lspreleasesdownload2025.03.07-17.42.36clojure-lsp-standalone.jar"
  version "2025.03.07-17.42.36"
  sha256 "671512207513256d93b516621122809ee04e4bbb36530ceaa534e00318e447b4"
  license "MIT"
  version_scheme 1
  head "https:github.comclojure-lspclojure-lsp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d{4}(?:[.-]\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a60374232f92726c43b6b564a229dc577a18c62a883249c8b7549dacb014d939"
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