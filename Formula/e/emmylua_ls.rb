class EmmyluaLs < Formula
  desc "Lua Language Server"
  homepage "https://github.com/EmmyLuaLs/emmylua-analyzer-rust"
  # The project name is `emmylua-analyzer-rust`, but it contains several crates, not all of which we install.
  url "https://ghfast.top/https://github.com/EmmyLuaLs/emmylua-analyzer-rust/archive/refs/tags/0.25.0.tar.gz"
  sha256 "dc58e6b3f268a9abed01c7fdab64934a45c6fbdcfcdfe703d7c4cddb601ada1b"
  license "MIT"
  head "https://github.com/EmmyLuaLs/emmylua-analyzer-rust.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8eabc71f18964bd5991e439a52ed6483d33241241e55044607c6e66909c093f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db747d4b63fb477241569f3c382e1053192f79b7ffe834bbf2cdd2d029332899"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3089f48f3ffff4336c5ed49ccbc7176ed5b61c9167bca1671838b13d423df46e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8eef0484aef0e036b5fbd21b08418972003241a8ce881d2108267e75f872290"
    sha256 cellar: :any,                 arm64_linux:   "f2efbd7cec97912c036dc3ed97714cd2e9999a91eafabe72093a80ac5ca5254b"
    sha256 cellar: :any,                 x86_64_linux:  "9aa7356a0fbafa1f0fab0f695691c98d5798ca05ff83985865a7f8fd432886bd"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/emmylua_ls")
    system "cargo", "install", *std_cargo_args(path: "crates/emmylua_doc_cli")
    system "cargo", "install", *std_cargo_args(path: "crates/emmylua_check")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/emmylua_ls --version")

    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3(bin/"emmylua_ls") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end