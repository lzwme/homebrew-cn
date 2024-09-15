class Crystalline < Formula
  desc "Language Server Protocol implementation for Crystal"
  homepage "https:github.comelbywancrystalline"
  url "https:github.comelbywancrystallinearchiverefstagsv0.14.0.tar.gz"
  sha256 "2a48e8eedb58580c40a8fb762777ec282b76f066329828630b9a340fcaa39e00"
  license "MIT"

  bottle do
    sha256 arm64_sequoia: "04c025cf72222a12e7bace4488abe1db03fdb859881c1df560d893fd04b38c13"
    sha256 arm64_sonoma:  "a27bb7dec5d3b8f171f466767b32d460542e6e03f9a745f0687b71b88e3470d9"
    sha256 arm64_ventura: "1b5663d19c5e693d49a6d65acf62ff5cb79c9a5c558ff10279fa7723cc21258f"
    sha256 sonoma:        "3ce22dbd2f15a2229a146b0f752c234b4b31d5a377b2a5eee705f6b1a6738c70"
    sha256 ventura:       "1c3a5faa5a063aea30cc10183c081dc79b6ebf3e8cfbc5d0872866850a7ae65e"
    sha256 x86_64_linux:  "08c38521309523883a86180ca5062a5c4b49e204f00fdee450b2da509523c2a7"
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