class VueLanguageServer < Formula
  desc "Vue.js language server"
  homepage "https:github.comvuejslanguage-tools"
  url "https:registry.npmjs.org@vuelanguage-server-language-server-3.0.0.tgz"
  sha256 "432f6637931f12e9f32e2a4699c51124022ca2ae1ac1374d75e9f135048fb8cc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5e6b819ef07d8bd2fadb3e777765028ada0f5515927e42c817d6f4b47d50bb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74f80549c32256f0c4e8d7efe53b89a2cf3c512ec69e2f11aebf4de2f4292b0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c8fa06dda2deb93b7c0c7f227e784d023ac6abbb736a938d6c6202a3286be99"
    sha256 cellar: :any_skip_relocation, sonoma:        "99ca26d76daadf39d9cd7aa8faff0dcf607ea56698d88be1097c47fcdfcc0245"
    sha256 cellar: :any_skip_relocation, ventura:       "7aeca38aa820ae70d365dd184f99c993e3aa71b18b18fd7d270aeadb31fa4866"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9573cbbffec01b92876a4bf6254b00f725747788f83b53e62db22212baa51425"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin*")
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

    Open3.popen3(bin"vue-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(^Content-Length: \d+i, stdout.readline)
    end
  end
end