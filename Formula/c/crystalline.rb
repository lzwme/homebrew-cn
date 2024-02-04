class Crystalline < Formula
  desc "Language Server Protocol implementation for Crystal"
  homepage "https:github.comelbywancrystalline"
  url "https:github.comelbywancrystallinearchiverefstagsv0.12.1.tar.gz"
  sha256 "83b9ef5e15a8dadc459460460a920b8e16a3cca443da699721d9e1b0e5b054a1"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "679c0f30f570a17df50bc2d126ceec56732a21e1f5408a968bb49dda5062b954"
    sha256 arm64_ventura:  "e66cc8613b4ec1b2411466fe30980f873226fac4beba530a3ece1d71a895d0cc"
    sha256 arm64_monterey: "5f41144f97dd73e797e54327af5a105ef203d10775ee6c7d5522cd77a3dcc80c"
    sha256 sonoma:         "84c537f8a28275e5569972c5b2d7d41040acf65b0dc51d1da93dd770e51f72cc"
    sha256 ventura:        "19637e256ea5adc2cf9a5f76816a4dea2209b126828b0b2e8794b280b8a1d7fc"
    sha256 monterey:       "04f031baa08f43d4a7546c1f94639ccf28ff408929485c09e63137d4c192fd88"
    sha256 x86_64_linux:   "9b2f9a01697cd2907c4b99238354bcca2cb876bc5cb76091843b16c81c158948"
  end

  depends_on "crystal"
  depends_on "libyaml"

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

    output = pipe_output("#{bin}crystalline", request, 0)
    assert_match "Content-Length", output
  end
end