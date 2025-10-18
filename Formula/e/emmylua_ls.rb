class EmmyluaLs < Formula
  desc "Lua Language Server"
  homepage "https://github.com/EmmyLuaLs/emmylua-analyzer-rust"
  # The project name is `emmylua-analyzer-rust`, but it contains several crates, not all of which we install.
  url "https://ghfast.top/https://github.com/EmmyLuaLs/emmylua-analyzer-rust/archive/refs/tags/0.16.0.tar.gz"
  sha256 "27468c156bfc300a729d7d581749bfef8211c2d7d9871f7ef04846589e7b0a2f"
  license "MIT"
  head "https://github.com/EmmyLuaLs/emmylua-analyzer-rust.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9c78d8d27dd002ebd66245373b668e7165708622cf0726a4d17b8261c28ac23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46eb7620aceb745e2706b70f27813576a8c6be5277896cd30dd2c049730c62ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4c20bf8aeb2ff435371c3da9a11c6a68feb1e1322a82e23a3d9bd2b3969972c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d3343f1ef568320874f346b768caac066fd4cdfee8b900f0590c329101ea46c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95d8a1b18c41268cfd07b93d3dc60cec639669ecb54653f230e5ca030caa24b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33fde44cc5fdf07a6378b8dc52b5be657943d31f99de4717f5b1eff15b149133"
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