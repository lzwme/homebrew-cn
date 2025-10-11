class EmmyluaLs < Formula
  desc "Lua Language Server"
  homepage "https://github.com/EmmyLuaLs/emmylua-analyzer-rust"
  # The project name is `emmylua-analyzer-rust`, but it contains several crates, not all of which we install.
  url "https://ghfast.top/https://github.com/EmmyLuaLs/emmylua-analyzer-rust/archive/refs/tags/0.15.0.tar.gz"
  sha256 "6282872ba4f65708d146c2dab1875906fa19cb017e98f4502da05a702811d39c"
  license "MIT"
  head "https://github.com/EmmyLuaLs/emmylua-analyzer-rust.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0999bd482d98ddc307beccd8b36216144620351f0451105f5ce111ef4faa81b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f9070294653aee1b59b6d8d879c98fcbf648ac9f3e0ddde798d5cd648ceea86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d390f1e5b784eeb282e5b1b5fb33886e23f29082ee87fb7fa3e258a37925b67a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed0187c508f74ec9cb23cc66839f48a8504174efdf9fc41757af4584cc3254e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a78889ab89365e173a4f68f103cc269729d73abcd1441aa2a0f2fc82f4e19506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d7837951f7545c838f6ae5c14072387b334d264eaa90f04213703d4972eb364"
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