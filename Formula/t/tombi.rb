class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "f4d1c13d7c54d3f3c206dd207efaa129d55945e6c6f9dfa8ce7793473faec397"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77ed7b95992c25b4c9db75df333835d2cfda52ee0204a6cfd4e1fed552e0e251"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09edf8ae849d5cda64ec0bc56dd508013302582ec7f8d83ccaae534fda85603a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ad3cc4bf67943103840da29a661de293b9409986905a962fe247d6e63238cb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "c078a763ca7ab58a52182f18e0045943ee3f2b584c545328a008f944454608d1"
    sha256 cellar: :any,                 arm64_linux:   "b4cb3d776321c1b5e456aa5e9b601654e99a5294d6a8fef503d8fed225c8266d"
    sha256 cellar: :any,                 x86_64_linux:  "70ae66a1309ece9c67ab5d9146ece67eb97a628faca60e818e507d9b30e919a9"
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