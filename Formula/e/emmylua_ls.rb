class EmmyluaLs < Formula
  desc "Lua Language Server"
  homepage "https://github.com/EmmyLuaLs/emmylua-analyzer-rust"
  # The project name is `emmylua-analyzer-rust`, but it contains several crates, not all of which we install.
  url "https://ghfast.top/https://github.com/EmmyLuaLs/emmylua-analyzer-rust/archive/refs/tags/0.23.0.tar.gz"
  sha256 "9720bf016002a8d0df6bdcdc7c4ac148d0bc13b11115f50ff314c6c1a047498b"
  license "MIT"
  head "https://github.com/EmmyLuaLs/emmylua-analyzer-rust.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d14cf1dc086e1c60a5481e97dc1c4b13ad189a934ad419335674af81e192b9a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3af09c9bdf7922d8a9112e576edfcfa59c3b1fdfd3d1c8db85df55f7c11ffa1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5cfc42f9f463b1ef88c92d2670bd9c7e5e01a8be7d92c099938cc89b546761f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4bc50f1ed575b913dbb338e92bac41fc2b21cf631ea1104783e9c8f77585b75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "346dd9ab20afa585ab7533ba49fc140c4e729542b5bdcbe088c1b9b5c1dbcedb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e24f92399ee53de3d21f16d164dbc332740e98ec3f948acc65305542585018ed"
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