class Crystalline < Formula
  desc "Language Server Protocol implementation for Crystal"
  homepage "https:github.comelbywancrystalline"
  url "https:github.comelbywancrystallinearchiverefstagsv0.14.1.tar.gz"
  sha256 "caa8cc661abc2ba63194983aae46e87c896d89c228a158521e40c34375d738f7"
  license "MIT"

  bottle do
    sha256 arm64_sequoia: "6a791148ac79644e6d3d0ba6bd0306e53f62a4f47871af5620bd6603c57f6889"
    sha256 arm64_sonoma:  "03a5cb50cd6ec32995ddb7276fc9c6a6513b5463a763a040faa1af7fd37adf42"
    sha256 arm64_ventura: "7fd5b91daba051719d1f5b1d3e61ac8013e41bd6f00c2b5e10a9551c0daa9fa1"
    sha256 sonoma:        "820c696641b7444f80fd17110cf333a81e6105088baf4d45c9fb68e542f8ee70"
    sha256 ventura:       "0322c8711ae76b2d53232f3b131f6bdbd6b637f734ea394ea9576c03add97c43"
    sha256 x86_64_linux:  "162c25a092ae85798b44eedfad082d82f44efdc537b0f4d29387dc8a69e3fd21"
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