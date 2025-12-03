class BaconLs < Formula
  desc "Rust diagnostic provider based on Bacon"
  homepage "https://github.com/crisidev/bacon-ls"
  url "https://ghfast.top/https://github.com/crisidev/bacon-ls/archive/refs/tags/0.24.0.tar.gz"
  sha256 "479b0addff30f13fec072afad1f37f54fb670b5fd2833287cb03cbb8827d9ab5"
  license "MIT"
  head "https://github.com/crisidev/bacon-ls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5736f518cd2ae61b64f24fa3b78fdc2a41f82c6b6940399b9cdddba0a88d4e0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "287d50d8daa641c978cb6fc73e539d58c2c1ec56d5221cfb7eca7b6a6f974dc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9ee5c8db01f98237e5b1122344b698b89fb6b45d9b662333ddf8027154e3565"
    sha256 cellar: :any_skip_relocation, sonoma:        "470f3fb58993a3078ec5d5641721e833aa6039378774a7fbcf2a59e5a0215409"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "affd38cc8978d3a301a0dd2ad3e3caf7ef88dc77385ae3c5c3028c4e1ad1fa71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32a8dbc9208a9b5063d8cafedcddba6f7ac3386cd83ffbe9208226dab28af607"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "open3"

    assert_match version.to_s, shell_output("#{bin}/bacon-ls --version")

    init_json = <<~JSON
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

    Open3.popen3(bin/"bacon-ls") do |stdin, stdout, _|
      stdin.write "Content-Length: #{init_json.bytesize}\r\n\r\n#{init_json}"
      stdin.close

      assert_match(/^Content-Length: \d+/i, stdout.read)
    end
  end
end