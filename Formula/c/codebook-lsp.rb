class CodebookLsp < Formula
  desc "Code-aware spell checker language server"
  homepage "https://github.com/blopker/codebook"
  url "https://ghfast.top/https://github.com/blopker/codebook/archive/refs/tags/v0.3.13.tar.gz"
  sha256 "c294f41c1743d3e443e835a3db29b2299b1b325bbbac6c63097ce365da823674"
  license "MIT"
  head "https://github.com/blopker/codebook.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7960cfb9461c38ab4ef2f06aa0ec9ccbe738eb1a06a184925b42f4ae6774c5bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f7ed7ad0e133e6f9f3b2162beba6ee515aa8b82901116d7958882484d6e1d81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ae5e7e14b157564ea89daec092c4549331a9fe33129d89bbde13f8f995b64ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f4f65b0021025513b1f244ca45325df792e2b92ffc8d75890dbc8b495687c41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5e703a578c1d805e82996ce62eefea3ed16bd9aba6eacd6feaa2b5f1af370e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "618281163c2a34aca972c757b3357cfbdf4794e2c64ce54841c91c873efd09b7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/codebook-lsp")
  end

  test do
    assert_match "codebook-lsp #{version}", shell_output("#{bin}/codebook-lsp --version")
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

    Open3.popen3(bin/"codebook-lsp", "serve") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 1
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end