class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.6.tar.gz"
  sha256 "de11211dbcb4330db1f46899fa4c7b63a46cfa00e7745a9f4f5d38b267ad6c60"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5d6770262140f8be05028b8adec4d92776890a8fea320973cd60f116e35f23e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ad36b60a606cdbc1a4fbbfc14511cb2a9fbbb1ac9099891b64cf29e282d3304"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d77740e0abf723a0e3f033f077371b56f9279c5645896b45f78e8b424e5ebcc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ad7c12f70ddad1f6cb886df8a5b77daa0724eab6806e4a953ce3b63dca6343c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "169b373fb4632c247c28c1991c9d150886ca956fa6cfeb0e96748423c534b699"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "262c63588181983f4abe684d851a31be66b34cfab651e4b49b6d65b8d1d323a1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/tombi-cli")
  end

  test do
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

    Open3.popen3(bin/"tombi", "lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 1
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end