class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.25.tar.gz"
  sha256 "76caaff00bf332addd12182cbba0e0ae90b6be9d8a91a0766647e14b95aad36d"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3e5c98afb4f3419e2ebcbd68fe5c852a4caddc9439a4f0fcc3e676362687e17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4ba5f9fac9a971fce6d7485ec95ccad92e99e6c7dcc443a108ad1def7eaf7ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53ab129d7f2d55c4197268b78c5078878b6f586bbc88465bfd82d8e1ebd97ba7"
    sha256 cellar: :any_skip_relocation, sonoma:        "4157e290b8f3bf60d56b84dba6ce9f514b52cbf091aabcba1f51332e92b26109"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "168f59aea20ba9187d6b584cc9ebc8640007cb6323169cf853f2a3443bf56f6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "feaed59f9bed5c68c07addd33c16a872efbcabc85d6bf03f0a285febc929210e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/tombi-cli")

    generate_completions_from_executable(bin/"tombi", "completion", shells: [:bash, :zsh, :fish, :pwsh])
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