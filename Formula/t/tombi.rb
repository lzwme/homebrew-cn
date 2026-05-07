class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.10.5.tar.gz"
  sha256 "e3b616f8e22b1731d26c025c4e5ff41657987bb44c7c1ed512d98f221058419c"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f852ae16b5b5c15476907bbb3ef59d250889c910134acee3a4b43234155703d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89892fa03094afa6118e998a2e32d6fd94a62bd82ad075320cdcab814c1d1c19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1220e1fead1f61f88b4c94a95891ff3ac7373a2add1940ae893da26ca41dcb7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7828b232a82281996afaf34491b413e9ba71a8178e3762e639e2c21ec71b86a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bc6734f8c4bce35f4e5cf67fb8aff94b42d06160ee7b70f0ba464a952e2af3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3a693e9fb1e777e0de4193b8063768a7c1d52d5058a6c22cfca7f05eb35ca85"
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