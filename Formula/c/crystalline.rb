class Crystalline < Formula
  desc "Language Server Protocol implementation for Crystal"
  homepage "https:github.comelbywancrystalline"
  url "https:github.comelbywancrystallinearchiverefstagsv0.14.1.tar.gz"
  sha256 "caa8cc661abc2ba63194983aae46e87c896d89c228a158521e40c34375d738f7"
  license "MIT"
  revision 2

  bottle do
    sha256 arm64_sequoia: "2c0bdae15a8c547f60aa6fa3bfb7be017765220a52a502042df386772bf7e078"
    sha256 arm64_sonoma:  "f80fba1300229e2723ab10499d28f3543dc8f22f9f9e7fb832ba1ffa70aa9210"
    sha256 arm64_ventura: "4c1591c4b6bab0a830b0bf897610cdaf0c96a4f3f7c2aeb84cb12af1a862933a"
    sha256 sonoma:        "a48d4440196fb81924b499468e1eba5cd4089b70a12a0c54be1e9b486d677c11"
    sha256 ventura:       "9036bf406494a7d96c7d7580a0587168641fab0cb753ee27a749ec49a624e092"
    sha256 x86_64_linux:  "5d2f756c55564ca49e939d310670b3fd6c868f483fb4ef93da63b57374198fdf"
  end

  depends_on "bdw-gc"
  depends_on "crystal"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "llvm"
  depends_on "pcre2"

  def install
    system "shards", "install"
    system "crystal", "build", ".srccrystalline.cr",
      "--release", "--no-debug",
      "-Dpreview_mt",
      "--progress", "--stats", "--time",
      "-o", "crystalline"

    bin.install "crystalline"
  end

  test do
    payload = <<~LSP_PAYLOAD
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
    LSP_PAYLOAD

    request = <<~LSP_REQUEST
      Content-Length: #{payload.size}

      #{payload}
    LSP_REQUEST

    output = pipe_output(bin"crystalline", request, 0)
    assert_match "Content-Length", output
  end
end