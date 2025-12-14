class TsQueryLs < Formula
  desc "LSP implementation for Tree-sitter's query files"
  homepage "https://github.com/ribru17/ts_query_ls"
  url "https://ghfast.top/https://github.com/ribru17/ts_query_ls/archive/refs/tags/v3.14.0.tar.gz"
  sha256 "cfe3bd81bd9fcd153e3813e8b6b7084eab40fc967d1eae4a4418637e37635b9d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb26613f8bb99d8ce15dd820297efc5fb7ba65a664cf5502c384f2b7d4f09361"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3109adce793b2f0eb7d07cbdea85e62d5b1cc00ce7d93fb1b3f1ce0d50de9ca3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fbc2340e74d90a00bc6d9e806c3ee9d34284c57d6d0328d0f47a2dd7db508dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "f10f1bb30ef7b205065c425efadce29cf9059581310439f95128366babe89409"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2b3690a5d19bbac3887dc1cbd5a1bf38deb42b9295f6c1ac613f21eb30d1723"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe3bb5ec2d2f1f7a1f5477a767d07dacce8aceebf3486a54da67e9e68cc9ff38"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input = <<~JSON
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

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output(bin/"ts_query_ls", input, 0)
  end
end