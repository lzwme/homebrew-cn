class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.54.tar.gz"
  sha256 "d09c930740cb15dd498ebf25d444d73da5c05c4269660af12f34b9d4b1e9d1da"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04ddf788dee2c444407a05009ec22ee70d94acb2064b33989fee2041d4c772a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8b543441213f7bcdde462052662b1edc3696b80e143fbcde253b57e50905dd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9728ceb09fadb4d55c8478b21965ac654d09b3c1da16ec666374fae9abf0157"
    sha256 cellar: :any_skip_relocation, sonoma:        "50ad719502a0892c701bca8a1d387ad26f99bb77df179e7a74e6717a359d3b01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb5d6d09cbdc744a96a9a91a5776c4fc9c958d322933f334bf0ea8e15ccf35c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "672ebce307a93a75e074e4a7fbb6e9abdc4d05f89bb54d04ddc8cce056fe24b0"
  end

  depends_on "rust" => :build

  def install
    ENV["TOMBI_VERSION"] = version.to_s
    system "cargo", "xtask", "set-version"
    system "cargo", "install", *std_cargo_args(path: "rust/tombi-cli")

    generate_completions_from_executable(bin/"tombi", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tombi --version")

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