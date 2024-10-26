class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https:github.comclojure-lspclojure-lsp"
  url "https:github.comclojure-lspclojure-lspreleasesdownload2024.08.05-18.16.00clojure-lsp-standalone.jar"
  version "20240805T181600"
  sha256 "ad0958adc999c260415b06bedbc4dc045cf3aa6cd300cf43a37687e7963a2c52"
  license "MIT"
  head "https:github.comclojure-lspclojure-lsp.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^(?:release[._-])?v?(\d+(?:[T.-]\d+)+)$}i)
    strategy :git do |tags, regex|
      # Convert tags like `2021.03.01-19.18.54` to `20210301T191854` format
      tags.filter_map { |tag| tag[regex, 1]&.delete(".")&.gsub(%r{[-]}, "T") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c23725002387b6bb97d39ff12ecafd87727a626eaf7a3cf6d163fee01e80d478"
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