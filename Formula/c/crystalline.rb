class Crystalline < Formula
  desc "Language Server Protocol implementation for Crystal"
  homepage "https://github.com/elbywan/crystalline"
  url "https://ghfast.top/https://github.com/elbywan/crystalline/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "7cab91e23bf2e7d87ab3e63c60a555507a00da709af1fad5fe55de44dadea71a"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "271065743219a98bbdfa2cf54bf0e8c0843f61b547e7a85bea1beb79494ad37c"
    sha256 arm64_sequoia: "81b18f436f8ba89702095829121aac7d9e9b8bf4d0ec2627a8186db4e6ddc745"
    sha256 arm64_sonoma:  "0d92647878164a397b81865615cbe68b493e32c1c6e9a0c67b5805cc46c565dd"
    sha256 sonoma:        "b902653312d57df9c6602b092913251c0fbc5ec99f74c0497e14e479f018fe52"
    sha256 arm64_linux:   "2266e86d128eb1f8e274765c3f3614d5b9292557afbff21dfac5644face3aecf"
    sha256 x86_64_linux:  "2b1698e798b88998ba1fe168269b0cbeefacef19a2ead5311d7aa51fa52a4aa5"
  end

  depends_on "bdw-gc"
  depends_on "crystal"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "llvm"
  depends_on "pcre2"

  def install
    system "shards", "install"
    system "crystal", "build", "./src/crystalline.cr",
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

    output = pipe_output(bin/"crystalline", request, 0)
    assert_match "Content-Length", output
  end
end