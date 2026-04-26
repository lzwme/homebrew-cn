class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.9.23.tar.gz"
  sha256 "115e39adc0adccc800502ce5d64ca5b442c57847b3375776c662da5bbd6a72de"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41bf5d234f61a0cd74c2c65f9c9f36b0203f8cfd911d468f1298cb7227cd0ff3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d14e03472a37ec8ecd111ada5027b09d90c4949bc43f5e752677aed3a825f45e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba54f455eb2fbdd7cf8f5f76bbf144cf09490abaac424b59f1b9d76e107459a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7af519a92f5275d6e2a05cf88ad7bc02f1aba1fd8a84f04b3462c4d36fc03d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3879aca8d5e4c5e7c92672748bdc981b38e48713822fb03b053de0d4936cae31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19cca5afda199dc81e4cda876ff34de4abb5945c9b6f26869ed304bb18f01688"
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