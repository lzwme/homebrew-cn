class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.2.5.tar.gz"
  sha256 "d7800803e95b5be217dfb7a45b379037b5511870f7bfe27a306ff47701ad3c44"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0656fdf77376065cb0997ed7a40a479737566d8629094ce13c3b53a850717708"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20bca6c18d9c19a4930c5b372e75eccec7f522b5d67c163e6be03fba24c11671"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21bfe4b044f572ffceaef3472634f1e69297054d1465d660c8304f8c0b422b14"
    sha256 cellar: :any_skip_relocation, sonoma:        "97786a34efd8e101e9e4f7efdd0bd9dfa563959992e456533b555b9ff1a160f1"
    sha256 cellar: :any,                 arm64_linux:   "efce50f537f1dda24ac2027bce7d7b99ec43cfc647aed740a32b1c173146852f"
    sha256 cellar: :any,                 x86_64_linux:  "13df1d54918e06fdb8b9796386d7aeaa10f0fe4c99f0157a88c84971c3fd5a41"
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