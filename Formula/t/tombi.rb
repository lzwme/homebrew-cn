class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "05207f7216dffd3bc395244d36739f559dbeb4d5fdd3699aa08f300af4c9aa1f"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd21e14367552d1fb125e06cf8474998560dc6896d09e9d23881b24cf307fc7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4da8b76afd74aab43c7a1964062f3b4b85c02bf1ec0c1b9652f21a467f99d12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bbd09cce0f991ae2c2d495847048b23a3a1added79ed45287ef38694e5ab4f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "0aa006fefe4cc73595fd2a13429b8c498a5432e0f401937301f30e5a4cd93dbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d7f8c34f9d9d0422dcb4ea4809c3d8b3eeff5977e7fee86ada60b7b42a84c89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0ee2ac4ac5c45366f401affdd98d97f9dc15213203c9d7201163e6a8774337f"
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