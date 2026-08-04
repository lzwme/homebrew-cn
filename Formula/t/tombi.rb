class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.2.6.tar.gz"
  sha256 "2d9216c9977d8ea2e89f980a65fb865960fe0f372af5050ceea52165c2cbef4b"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77dc15c7cd1d0f3071561e03e9fd93221d40a26c8efca293b5bfc2d1b01808c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0730350c9c1bea12a4488719c20a335bb09188b895fc5869ae483732e6e17128"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46166e8b2ba08d79a3a4dedd6d3ea344d982e096f4611c6f646081761fe348ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b17495fcf8ffeea4174c7fb9ded08dcc59e060a8d65b6ec0a1465ec251cd3f1"
    sha256 cellar: :any,                 arm64_linux:   "ddcfd25627901353ff758bade972ae38142a58b67f847428bf207efd71b05e47"
    sha256 cellar: :any,                 x86_64_linux:  "6b64d7faa6c507d9a5a0fa7cc4d7f1e180b4e0203b6d0b2a14a6aec296883637"
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