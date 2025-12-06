class EmmyluaLs < Formula
  desc "Lua Language Server"
  homepage "https://github.com/EmmyLuaLs/emmylua-analyzer-rust"
  # The project name is `emmylua-analyzer-rust`, but it contains several crates, not all of which we install.
  url "https://ghfast.top/https://github.com/EmmyLuaLs/emmylua-analyzer-rust/archive/refs/tags/0.18.0.tar.gz"
  sha256 "3606ef50a29792b0edd0b968a0fd0fd2c4dc409e639216604f807439e1bd62c3"
  license "MIT"
  head "https://github.com/EmmyLuaLs/emmylua-analyzer-rust.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1e634365386f9d4d138d61c5d183deefccde8f25adfa824eadc05e3ceb54f63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "442c79fb68464567d4cab165b12c52fcc560a1dcc9fefd4b2964ad15a4ac380b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cd0b611a1ebafcf42ae17186121e78d81d1cb017839bc82c15cb2f2859cd100"
    sha256 cellar: :any_skip_relocation, sonoma:        "59092358847db63e9500ad00bc96ee20a6c13a7ef3e2c124fa46bd7c478aaf60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38be692287d237ee09432c8c9f77a0a5192e495dde922df8ef1b32a9aaea2b52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b79e10bafb9acc913d5e370d963831a787eeb530bdad60657fa2a6136534752"
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