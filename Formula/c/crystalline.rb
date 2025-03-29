class Crystalline < Formula
  desc "Language Server Protocol implementation for Crystal"
  homepage "https:github.comelbywancrystalline"
  url "https:github.comelbywancrystallinearchiverefstagsv0.16.0.tar.gz"
  sha256 "4639607061f8d137d2dd1a66cfa673052930d628ef9da7f65f8cab70c615e6e1"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_sequoia: "cf5201379c7f3a557d824fede5d2907639909697d52c19b4afab74474c09a5cb"
    sha256 arm64_sonoma:  "4b92267951f1379ed94a47cc66cea68173e3f91df16bb3b74a5e95f4b731ac6c"
    sha256 arm64_ventura: "da3ca08d7c3894ee07f6e66fb55ac1e77b703640dc1b92593cf9d371ef4867a4"
    sha256 sonoma:        "d62d6143e4fa160998bc8db54cecd859ebd29041d95513a25c5c11b73bb3cf81"
    sha256 ventura:       "f4858fb3995667be1666d0fc67d112140dfe087b2dd6e33bdcd250e054ce8447"
    sha256 x86_64_linux:  "17ffa20de818c4d277b20081fe3f33b0f9112915f88143efacf2dc854a1b686d"
  end

  depends_on "bdw-gc"
  depends_on "crystal"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "llvm@19"
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