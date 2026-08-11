class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.2.10.tar.gz"
  sha256 "48b1aa357b2b520cfcae02feefffc2384ed96a683fb34e290da955b60742abc7"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6810ecab7e58f90ccb7b471875938cb55010204c4a984250f9793581af964df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "928192d61d56dd5d6dbe0a9065ae8a8dc0b2a076b0e208c4515f479c6efa638d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d644c0051959b1d207db0ad73b4cd5c42b564e679095d27ced54ad806497be38"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bf2f10eacbc816f822956c6cdbfe3f0de4ed348577f0be7a28aa070617270f1"
    sha256 cellar: :any,                 arm64_linux:   "1372aad53efb424a5033006622fe84815248415263dc45a7d7dac5b249c22adb"
    sha256 cellar: :any,                 x86_64_linux:  "628e33ae31710a3cfd90223bce9daade1b6b1058e54f6301c0d05835a874b4ba"
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