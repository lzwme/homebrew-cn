class Crystalline < Formula
  desc "Language Server Protocol implementation for Crystal"
  homepage "https:github.comelbywancrystalline"
  url "https:github.comelbywancrystallinearchiverefstagsv0.17.0.tar.gz"
  sha256 "7ca2d4e0041fd49a6a783606ff40a0a63d7948d382f480b3f3581a4cf264ce63"
  license "MIT"

  bottle do
    sha256 arm64_sequoia: "a89e5e4f6c5e8420b351607a9bd1017511a9ccaea8159becf47dab66dd4835f5"
    sha256 arm64_sonoma:  "f38e3fcb461989c048e97fb4285a101f37b06335b3518a037cbeded42b26531f"
    sha256 arm64_ventura: "20cc7ad8918d96f0e73ae70aa82393b43f4ce7e894d4825d8648db53488fa395"
    sha256 sonoma:        "2b2cffc5a22e2ea946c586d34e31458d7ab0d087dcea537abe1483d625c51f4f"
    sha256 ventura:       "357a43d72b43ada41e33fcfeeb4e1e04be8508abbb5294e88d20e15cb1606f5b"
    sha256 x86_64_linux:  "d1c28873a745b3040cc6d5d9e9a2669890be5d3d6fbe8cb60494f2b3c5cdfc92"
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
    payload = <<~JSON
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

    request = <<~LSP_REQUEST
      Content-Length: #{payload.size}

      #{payload}
    LSP_REQUEST

    output = pipe_output(bin"crystalline", request, 0)
    assert_match "Content-Length", output
  end
end