class BeancountLanguageServer < Formula
  desc "Language server for beancount files"
  homepage "https://github.com/polarmutex/beancount-language-server"
  url "https://ghfast.top/https://github.com/polarmutex/beancount-language-server/archive/refs/tags/1.6.0.tar.gz"
  sha256 "37c032fcb26b42b849a727b5db1b615d7fe528b5d7c1ce75283ad06bf2be8692"
  license "MIT"
  head "https://github.com/polarmutex/beancount-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4aee4c157ef170104f59f7ca3dd54807737af4e1304ede24a458d67369ddff43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "326ccb34aacf6cad8e3b9e6c98cc6fb21f01a2fb6ce97ab4f49d6f1292e4cedb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e41761d98a52f4d7ce4199f17ba87975374d8c0a798a88c705d52ac2cdae8e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e8355660304578bd13ad5f52514d8120cdc357b1eb24089f59882f98e46287c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22cc5240bc2254b196c0a322715defebcd9d3e09012d09aec9c764d32837545a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccc75c051c7e2c3ae06c1961450bf4da8e4c1a3f8590f5286362c5928ab7a093"
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