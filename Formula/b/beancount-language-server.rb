class BeancountLanguageServer < Formula
  desc "Language server for beancount files"
  homepage "https://github.com/polarmutex/beancount-language-server"
  url "https://ghfast.top/https://github.com/polarmutex/beancount-language-server/archive/refs/tags/1.9.0.tar.gz"
  sha256 "92a0c82b939ad66769e91270fdf3905717913c9ebf79dd62b6a50f5f8d7fa827"
  license "MIT"
  head "https://github.com/polarmutex/beancount-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ab3735ebd3988b9a39be66ef707d83b888b1d8756fed4c95210bf2d0d5d5236"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ffd2d2ffdb0c9c648f0b0c8185033c1c949b6962401180623c7f4c6423c5805"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdc0854fbf32f846ca4a3bd72ddd2233cf5e1c8edd3a05a52725d66ec7eba75d"
    sha256 cellar: :any_skip_relocation, sonoma:        "eefdb2597ea64a79eccd58a74d1d8130ff0b5ea6f43e6ad24a5de68368ed62b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57f46e781bc3f726978531654b47b1a46c07b44b0980b2147cdbcf01c23eca31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5b9fdeeeae9ff12ecf0eabeb54267e69062d1106a8681b01f77daa17cd27fc9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/lsp")
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

    Open3.popen3(bin/"beancount-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end

    assert_match version.to_s, shell_output("#{bin}/beancount-language-server --version")
  end
end