class Crystalline < Formula
  desc "Language Server Protocol implementation for Crystal"
  homepage "https://github.com/elbywan/crystalline"
  url "https://ghfast.top/https://github.com/elbywan/crystalline/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "8693e91c0f2afa9afa66885aa2bbdc971e539ff95e3d89b2f5d499d07acad02d"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_golden_gate: "6ab9d531bcf06d3e4047657f7381b44981b5c0490888eac83700457438b40057"
    sha256 arm64_tahoe:       "fcadc0e91448d09a06ad11ae9d47a183e31f2672d91b2a084e9022929b0f19c6"
    sha256 arm64_sequoia:     "afd54b02d3320d7d80d912c9f3f76493f1c596af5c93791272f9e547fa211b6b"
    sha256 arm64_linux:       "d7b8de1e6ebe6026c1cfc165c64c03e11a342d510ef66457e3fc81f13dc22aad"
    sha256 x86_64_linux:      "c85501ee8bf9782375ddc4047bd27dd1d5ddab0a3d02ae86ce57aa4d43acc2aa"
  end

  depends_on "bdw-gc"
  depends_on "crystal"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "llvm"
  depends_on "pcre2"

  deny_network_access!

  def fetch
    system "shards", "install", "--production", "--skip-postinstall"
  end

  def install
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