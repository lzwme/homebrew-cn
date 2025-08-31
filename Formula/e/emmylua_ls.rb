class EmmyluaLs < Formula
  desc "Lua Language Server"
  homepage "https://github.com/EmmyLuaLs/emmylua-analyzer-rust"
  # The project name is `emmylua-analyzer-rust`, but it contains several crates, not all of which we install.
  url "https://ghfast.top/https://github.com/EmmyLuaLs/emmylua-analyzer-rust/archive/refs/tags/0.12.0.tar.gz"
  sha256 "8108577bf598a91a2aa296a270eccc6afab8d6adb23be196ee1d9a5a93de5dd5"
  license "MIT"
  head "https://github.com/EmmyLuaLs/emmylua-analyzer-rust.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7d33fa5bbcc8959cf630b2c5542e4f55e65fd5ebf21acb0f19c5f3ad1d018aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b09fe5713263c6338fc9e9d11cfb3f60cdec018a5afeedf755034ede1f1d983b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "64299086caf7163a978502a485763dbff4fc02c99e83494a46d802ac2fefadbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "e46518bc9e6570c1cbb34297e6a3e6e94a9805f5f4b3d6d1839f43c8de76c64a"
    sha256 cellar: :any_skip_relocation, ventura:       "4fd90bf76662e118ef5d655bce9a56ae8340b36670424478d6094829c42896c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d14d77d2118aaabb4d2a590a09746cc429741f5fe53351ea1a5e6a5b2290ac85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6060a05d2a395ae1edefa829908e0a87feb5192bd6377ff6351940f2e48124af"
  end

  depends_on "rust" => :build

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