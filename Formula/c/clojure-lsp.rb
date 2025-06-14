class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https:github.comclojure-lspclojure-lsp"
  url "https:github.comclojure-lspclojure-lspreleasesdownload2025.06.13-20.45.44clojure-lsp-standalone.jar"
  version "2025.06.13-20.45.44"
  sha256 "11e28abda97f57dfc0cee3e4015b40ef98c6d9ee633a4583b3aa1957cba5211d"
  license "MIT"
  version_scheme 1
  head "https:github.comclojure-lspclojure-lsp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d{4}(?:[.-]\d+)+)$i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d76985179a3d8c069da2c240f8436264b20441ee16cc875215c26f37ff37fbc2"
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