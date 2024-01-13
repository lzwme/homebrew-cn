class Crystalline < Formula
  desc "Language Server Protocol implementation for Crystal"
  homepage "https:github.comelbywancrystalline"
  url "https:github.comelbywancrystallinearchiverefstagsv0.12.0.tar.gz"
  sha256 "d25815bf3c8c0ffaa958e1c1bd4dbacbc41dc65fb3c2a99404ca5b1d9bdc8170"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "bb954e1c37b9bb6d56be6c8f0564236919ffc6e32073b8adb57e5f20d94cacc3"
    sha256 arm64_ventura:  "4e9788588a41b4b2eca8935a947ba9ccae61cd60d6f0b784d851505a2d2f4c1d"
    sha256 arm64_monterey: "98e782368fbb0a93fab592fc66e065b3b54715c6d604e41c08f1c3bda04ad3f3"
    sha256 sonoma:         "1cd7dfeb307cc2da0d61ff829a300b45e30bee1b7e2a83129ee79b5d5f1c0a71"
    sha256 ventura:        "dedeb393fa9345a79c99974cee583d2e4a4961e55ce6c3e0494365860cea0c1d"
    sha256 monterey:       "7ca06e07ec82054eb5147d9f62568bb815c0f6abbb6e34569a9ea85786f78f62"
    sha256 x86_64_linux:   "b85561d547320921d6f58a9aad3450bff27dca64135bff5464272646014746c1"
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