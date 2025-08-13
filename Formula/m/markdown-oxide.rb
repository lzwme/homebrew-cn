class MarkdownOxide < Formula
  desc "Personal Knowledge Management System for the LSP"
  homepage "https://oxide.md"
  url "https://ghfast.top/https://github.com/Feel-ix-343/markdown-oxide/archive/refs/tags/v0.25.6.tar.gz"
  sha256 "6d56f7c034d0f13c4d0692a850620107892483dcc107dddc190ed988516338d5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b85b448d0be203d1914be41604bb708062407e244d8b3e99d1ba0dfc82e2e5d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebac725ff73017017b83d51bd0aebd904a5dda0c19929f971fa548e887b35005"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da1e8e7de35d12c6914e7c2aec783e0d76c4803c6139865b1792f408e243aef7"
    sha256 cellar: :any_skip_relocation, sonoma:        "c91ae1560d977a0ba1f468fada60ad253a6f5755f549cf3ee1504af7da69a23f"
    sha256 cellar: :any_skip_relocation, ventura:       "ead3d81e6e3598efd072fd62706edf62f75b837af3bcd40a5af5c19ff971a94c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8683496edb75d2e670853d57527d4e16fc6cf56a4dd94acca6a443d1c02d9964"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19209ac7d8990d4d05d973a32520e50bad50b2401057efc9341d55761a737a3b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
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
    assert_match(/^Content-Length: \d+/i,
      pipe_output(bin/"markdown-oxide", "Content-Length: #{json.size}\r\n\r\n#{json}"))
  end
end