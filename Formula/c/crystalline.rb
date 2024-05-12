class Crystalline < Formula
  desc "Language Server Protocol implementation for Crystal"
  homepage "https:github.comelbywancrystalline"
  url "https:github.comelbywancrystallinearchiverefstagsv0.13.0.tar.gz"
  sha256 "ed088a19236f83ae1a2a30e589f30e9838ba91bb475c492cf4c1ae0c9a9b468d"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "9ab649b6bac6cc93972daecb2b8b9367ec04200d65b7e6ed7200259272a8735f"
    sha256 arm64_ventura:  "9ebead1426d071d94c4e88eeb6e8e03485ed4fbaf34eb61ec3ed10e07d579add"
    sha256 arm64_monterey: "bde64aed7cb033ccce5af70e58e2eb7ebf989256e1ef36f264328f9fdf35c634"
    sha256 sonoma:         "cec306e84e7e9a6530775c2caeaf69eb365caad715e5a37af6251bbf39d05e6f"
    sha256 ventura:        "b8627895d7f842c282573d98d644f3265beaa668cc451d0b28b11348ae767708"
    sha256 monterey:       "6606c1222538281a3df7a01a44a72ddea3a7c8db9df9a7e86569764d76d8103f"
    sha256 x86_64_linux:   "a834c1fa44e051040b3198a9cc6c5dc13d2c1db0239019cd1929d05b5359842f"
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