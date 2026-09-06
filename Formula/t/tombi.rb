class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "8090dafdc32a4e1cb8d7330a4ce87ed916da25155ec6957555e6da68827a502d"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3caf4c1611e5a22cabb492ee979567d9771d4f08e0d42e00fe4ad7647a6edd18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "510ca515562c8cdf331c29d4a1da2b34fc58d7974e00108c4994913bca06cba0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e7f7e9d246fbc3243b70fc768ef9d4e89434f75578d22cf99bc3e9bf0f661ce"
    sha256 cellar: :any,                 arm64_linux:   "627a360852e949df70e2b5e402314410b9827c542c84e95080016c16c88ce852"
    sha256 cellar: :any,                 x86_64_linux:  "c077b558ff430a24b90522193c136703cd2c0e78f286ac86649c536bc89c004f"
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