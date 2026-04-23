class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.9.21.tar.gz"
  sha256 "4bdb23a6c3297d7e05b98d07d965c17a29cc57f26529822c0ccd9ea27ac270b6"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e080c1fe22d6100a3d02072c49f8a59a514eefeef80cdb1a014c2fd8a3e8d23c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3933152ab7c7ff2e10db3d4fcbdbdb65cb35d2a93c15df2faa2a59a7650ef37f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cd22bffacd1216e222bd92a0d01c880c5fbfaee409c1590dbd6600b029e43f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "454da996e5f9a68e320aabf508388e55faf87748b0055204fc83d55732afe075"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ff4a624cda731f26f7d20cbba60b39cb82a8ba222fe49bd534702f680aadfdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df367b62fa198c1d8fee29ef50eef4cb735f23888ab9e48ae26b336d9821afcc"
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