class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.39.tar.gz"
  sha256 "215e4d9a1588c087ce67a0e0ff3c96d0c2166501d1c1970d6427af4f3e6cd576"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03687171d4c3ad85942326dcddac28aaea6b7722df1bf25e6212cb015c31d392"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00663d0685ec9ff744db19133fa613a525f4d28fe04ed8f423dd676a0f32c001"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa62798b23bc55c8abdd9148d3aa267ac457eaf45ea8442f9753df2d51d77e33"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbe5a07e3f08b8efd8bcfe0449cafec14be2e429502eee6ee8fbe47608476f49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6169df85b03b0f8773bcc6b9acda9a6ee4b19787cfd022a46906d2cf1e0a6241"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46c03eaaa1c631b27075a2419a96cf0c037a2aab1047b3cf935d2b0abbe262cd"
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