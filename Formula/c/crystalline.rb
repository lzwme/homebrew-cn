class Crystalline < Formula
  desc "Language Server Protocol implementation for Crystal"
  homepage "https:github.comelbywancrystalline"
  url "https:github.comelbywancrystallinearchiverefstagsv0.14.1.tar.gz"
  sha256 "caa8cc661abc2ba63194983aae46e87c896d89c228a158521e40c34375d738f7"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_sequoia: "325a6b36db0895dd4d690b735bc2d51b610e2484418551ea4f6d79068036f28f"
    sha256 arm64_sonoma:  "7dc766c53c793bd6a983e774d12e039e237a10ed8494d19879a8e1f05fb9864e"
    sha256 arm64_ventura: "3cd0459c1bb8ffcda56a1cbf1febf08d9be15ffa5d966a0f118e077e6b4a3bb6"
    sha256 sonoma:        "f64cd7d8667ee0f0a002360f27c435580a227ad655608352bf413ade68f2edb9"
    sha256 ventura:       "53e251e0463de322579586df86942fc5e9e5df8ac67a9497c91cf8b7e2b74a19"
    sha256 x86_64_linux:  "e3326305c34cd0c58d44a0f13188f870c3f28d13dfbeac8e966e7b4b89dc55f9"
  end

  depends_on "bdw-gc"
  depends_on "crystal"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "llvm@18"
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